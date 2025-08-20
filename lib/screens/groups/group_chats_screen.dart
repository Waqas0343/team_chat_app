import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/group_chat_controller.dart';

class GroupChatsScreen extends StatelessWidget {
  const GroupChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupChatController controller = Get.put(GroupChatController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
      ),
    );
  }
}
