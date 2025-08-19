import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../services/storage_service.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class GroupChatScreen extends StatelessWidget {
  final String groupId;
  GroupChatScreen({required this.groupId});

  final ChatService _chatService = ChatService();
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Group Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getGroupMessages(groupId),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message,
                      isMe: message.senderId == userId,
                    );
                  },
                );
              },
            ),
          ),
          ChatInput(
            onSendMessage: (content, type) {
              _chatService.sendMessage(
                groupId,
                Message(
                  id: '',
                  senderId: userId,
                  content: content,
                  type: type,
                  timestamp: DateTime.now(),
                ),
              );
            },
            onSendImage: _storageService.uploadImage,
            onSendVoice: _storageService.uploadVoice,
          ),
        ],
      ),
    );
  }
}