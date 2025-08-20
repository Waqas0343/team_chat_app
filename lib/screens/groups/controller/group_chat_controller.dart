import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../models/message_model.dart';

class GroupChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var groupMessages = <Message>[].obs;
  final TextEditingController messageController = TextEditingController();
  var groupId = ''.obs;
  var currentUserId = ''.obs;


  Future<String> createGroup(String groupName, List<String> memberIds) async {
    final groupId = (await _firestore.collection('groups').add({
      'name': groupName,
      'members': memberIds,
      'createdAt': FieldValue.serverTimestamp(),
    })).id;
    return groupId;
  }

  Future<void> sendGroupMessage(String groupId, Message message) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(message.toMap());
  }

  void listenGroupMessages(String groupId) {
    _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      groupMessages.value = snapshot.docs
          .map((doc) => Message.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
