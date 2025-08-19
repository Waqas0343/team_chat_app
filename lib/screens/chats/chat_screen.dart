import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/app_constant_file/app_images.dart';

import '../../widgets/chat_input.dart';
import '../../widgets/message_bubble.dart';
import 'controller/chat_screen_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final ChatScreenController controller = Get.put(ChatScreenController());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(MyImages.logo),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Muhammad Waqas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: controller.startCall,
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
        body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (ctx, index) {
                  final message = controller.messages[index];
                  return MessageBubble(
                    message: message,
                    isMe: message.senderId == controller.currentUserId,
                  );
                },
              );
            }),
          ),
          ChatInput(
            onSendMessage: (content, type) {
              if (type == 'text') controller.sendTextMessage(content);
            },
            onSendImage: controller.uploadImage, // <-- NO parentheses
            onSendVoice: controller.uploadVoice, // <-- NO parentheses
          ),
        ],
      ),
    );
  }
}
