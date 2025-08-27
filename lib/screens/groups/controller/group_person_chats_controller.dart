import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/message_model.dart';

class GroupPersonChatsController extends GetxController {
  final isChatLoading = true.obs;
  final messages = <Message>[].obs;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  late String groupId;
  late String groupName;
  late String groupImage;
  late List<dynamic> members;
  late String createdBy;

  @override
  void onInit() {
    super.onInit();

    final group = Get.arguments as Map<String, dynamic>;
    groupId = group['id'];
    groupName = group['name'] ?? 'Unknown Group';
    groupImage = group['image'] ?? '';
    createdBy = group['createdBy'] ?? '';
    members = group['members'] ?? [];

    listenMessages();
  }

  void listenMessages() {
    FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => Message.fromMap(doc.data(), doc.id))
          .toList();
      isChatLoading.value = false;
    });
  }

  Future<void> sendTextMessage(String text) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "senderId": currentUserId,
      "type": "text",
      "content": text,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<String?> uploadImage() async {
    // TODO: implement Firebase Storage image upload
    return null;
  }

  Future<String?> uploadVoice() async {
    // TODO: implement Firebase Storage voice upload
    return null;
  }

  Future<void> sendImageMessage(String url) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "senderId": currentUserId,
      "type": "image",
      "content": url,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendVoiceMessage(String url) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add({
      "senderId": currentUserId,
      "type": "voice",
      "content": url,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
