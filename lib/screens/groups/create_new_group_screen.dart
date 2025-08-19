import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_styles/app_constant_file/app_colors.dart';
import 'controller/create_group_controller.dart';

class CreateNewGroupScreen extends StatelessWidget {
  const CreateNewGroupScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final CreateGroupController controller = Get.put(CreateGroupController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.groupName.value = value,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.allUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.allUsers[index];
                  final isSelected = controller.selectedUserIds.contains(user.id);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl.toString()),
                    ),
                    title: Text(user.displayName),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: MyColors.primaryColor)
                        : Icon(Icons.radio_button_unchecked),
                    onTap: () => controller.toggleUserSelection(user.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
        onPressed: controller.groupName.isEmpty || controller.selectedUserIds.isEmpty
            ? null
            : controller.createGroup,
        backgroundColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      )),

    );
  }
}
