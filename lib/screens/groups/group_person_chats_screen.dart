import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/group_person_chats_controller.dart';

class GroupPersonChatsScreen extends StatelessWidget {
  const GroupPersonChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupPersonChatsController controller = Get.put(GroupPersonChatsController());
    return const Placeholder();
  }
}
