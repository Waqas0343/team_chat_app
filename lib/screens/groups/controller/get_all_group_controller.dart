import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetAllGroupController extends GetxController {
  final RxList<Map<String, dynamic>> groups = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = RxBool(true);
  @override
  void onInit() {
    listenUserGroups();
    super.onInit();
  }

  void listenUserGroups() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      isLoading.value = false;
      return;
    }

    FirebaseFirestore.instance
        .collection("groups")
        .where("members", arrayContains: currentUser.uid)
        .snapshots()
        .listen((snapshot) {
      groups.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "name": data["name"] ?? "",
          "createdBy": data["createdBy"] ?? "",
          "image": data["image"] ?? "",
          "members": data["members"] ?? <String>[],
        };
      }).toList();

      isLoading.value = false; // ✅ first snapshot aa gaya
    }, onError: (_) {
      isLoading.value = false;
    });
  }
}
