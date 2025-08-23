import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/routes/app_routes.dart';
import '../../app_styles/app_constant_file/app_colors.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return  Center(child: CircularProgressIndicator());
              }
              if (controller.filteredList.isEmpty) {
                return  Center(child: Text("No users found"));
              }
              return ListView.builder(
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredList[index];
                   return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                      child: user.photoUrl == null ? Icon(Icons.person) : null,
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(user.email),
                    trailing: Obx(() {
                      final isSelected = controller.selectedUsers.any((u) => u['id'] == user.id);
                      return Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.green : null,
                      );
                    }),
                    onTap: () {
                      controller.toggleSelection(user);
                    },
                  );

                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(controller.selectedUsers.isEmpty){
            Get.snackbar("Error", "Select at least one member");
            return;
          }
          Get.toNamed(AppRoutes.createGroupDetailScreen, arguments: {
            'members': controller.selectedUsers.toList(),
          });
        },
        backgroundColor: MyColors.primaryColor,
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),

    );
  }
}
