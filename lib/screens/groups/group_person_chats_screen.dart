import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/message_bubble.dart';
import 'controller/group_person_chats_controller.dart';

class GroupPersonChatsScreen extends StatelessWidget {
  const GroupPersonChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupPersonChatsController controller = Get.put(GroupPersonChatsController());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: controller.groupImage != null &&
                  controller.groupImage!.isNotEmpty
                  ? NetworkImage(controller.groupImage!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: controller.groupImage == null ||
                  controller.groupImage!.isEmpty
                  ? const Icon(Icons.group, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              controller.groupName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isChatLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text("No messages yet. Start the conversation!"),
                );
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
              if (type == 'image') controller.sendImageMessage(content);
              if (type == 'voice') controller.sendVoiceMessage(content);
            },
            onSendImage: controller.uploadImage,
            onSendVoice: controller.uploadVoice,
          ),
        ],
      ),
    );
  }
}
