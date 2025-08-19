import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/call_service.dart';
import '../services/chat_service.dart';
import '../services/storage_service.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import 'call_screen.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String receiverId;
  ChatScreen({required this.chatId, required this.receiverId});

  final ChatService _chatService = ChatService();
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () async {
              final callId = await CallService().startCall(receiverId);
              if (callId.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallScreen(callId: callId),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(chatId),
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
                chatId,
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