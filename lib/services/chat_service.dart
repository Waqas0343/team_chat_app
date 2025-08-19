import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> startChat(List<String> participants) async {
    final chatId = (await _firestore.collection('chats').add({
      'participants': participants,
    })).id;
    return chatId;
  }

  Future<void> sendMessage(String chatId, Message message) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<String> createGroup(String groupName, List<String> memberIds) async {
    final groupId = (await _firestore.collection('groups').add({
      'name': groupName,
      'members': memberIds,
      'createdAt': FieldValue.serverTimestamp(),
    })).id;
    return groupId;
  }

  Stream<List<Message>> getGroupMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), doc.id))
        .toList());
  }
}