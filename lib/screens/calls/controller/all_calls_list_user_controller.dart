import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';

class CallItem {
  final String userName;
  final String userImage;
  final bool isVideo;
  final DateTime callTime;

  CallItem({
    required this.userName,
    required this.userImage,
    required this.isVideo,
    required this.callTime,
  });

  factory CallItem.fromMap(Map<String, dynamic> data, String currentUserId) {
    final bool isCaller = data['callerId'] == currentUserId;
    return CallItem(
      userName: isCaller ? data['receiverName'] ?? "Unknown" : data['callerName'] ?? "Unknown",
      userImage: isCaller ? data['receiverImage'] ?? "" : data['callerImage'] ?? "",
      isVideo: data['isVideo'] ?? false,
      callTime: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}



class AllCallsListUserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var calls = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCalls();
  }

  Future<void> fetchCalls() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (currentUid.isEmpty) return;

    try {
      // Caller query
      final callerQuery = await _firestore
          .collection("calls")
          .where("callerId", isEqualTo: currentUid)
          .get();

      // Receiver query
      final receiverQuery = await _firestore
          .collection("calls")
          .where("receiverId", isEqualTo: currentUid)
          .get();

      final allDocs = [...callerQuery.docs, ...receiverQuery.docs];

      // Sort by timestamp
      allDocs.sort((a, b) {
        final t1 = (a.data()["timestamp"] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        final t2 = (b.data()["timestamp"] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        return t2.compareTo(t1);
      });

      calls.clear();

      for (var doc in allDocs) {
        final data = doc.data();
        final otherUserId =
        data["callerId"] == currentUid ? data["receiverId"] : data["callerId"];

        final userDoc = await _firestore.collection("users").doc(otherUserId).get();
        final userData = userDoc.data();

        Debug.log("User data for $otherUserId: $userData");

        calls.add({
          "userId": otherUserId,
          "userName": userData?["name"] ?? userData?["displayName"] ?? data["callerName"] ?? "Unknown",
          "userImage": userData?["profileImage"] ?? userData?["photoUrl"] ?? data["callerImage"] ?? "",
          "isVideo": data["isVideo"] ?? false,
          "status": data["status"] ?? "unknown",
          "timestamp": (data["timestamp"] as Timestamp?)?.toDate() ?? DateTime.now(),
        });
      }


      Debug.log("✅ Calls fetched: ${calls.length}");
    } catch (e) {
      Debug.log("❌ Error fetching calls: $e");
    }
  }
}


