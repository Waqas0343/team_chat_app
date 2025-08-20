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
                itemCount: controller.filteredList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: MyColors.primaryColor,
                        child:  Icon(Icons.group_add, color: Colors.white),
                      ),
                      title:  Text(
                        "New Group",
                        style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16
                        ),
                      ),
                    );
                  }
                  final user = controller.filteredList[index - 1];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null ?  Icon(Icons.person) : null,
                    ),
                    title: Text(
                      user.displayName,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(user.email),
                    trailing: Text(
                      user.lastSignIn != null
                          ? controller.dateFormat.format(user.lastSignIn!)
                          : "N/A",
                    ),
                    onTap: () {
                      // Handle single user tap if needed
                    },
                  );
                },
              );
            }),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      )

    );
  }
}
