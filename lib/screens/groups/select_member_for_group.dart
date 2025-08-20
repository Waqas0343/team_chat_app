import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/select_member_for_group_controller.dart';

class SelectMemberForGroup extends StatelessWidget {
  const SelectMemberForGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectMemberForGroupController controller = Get.put(SelectMemberForGroupController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
      ),
    );
  }
}
