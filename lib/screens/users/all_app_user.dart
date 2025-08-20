import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';
import 'controller/all_app_user_controller.dart';

class AllAppUser extends StatelessWidget {
  const AllAppUser({super.key});

  @override
  Widget build(BuildContext context) {
    final AllAppUserController controller = Get.put(AllAppUserController());

    return Scaffold(
      appBar: AppBar(
        title:  Text("All Users"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator());
        }

        if (controller.usersList.isEmpty) {
          return  Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: controller.usersList.length,
          itemBuilder: (context, index) {
            final user = controller.usersList[index];
            return ListTile(
              leading:  CircleAvatar(child: Icon(Icons.person)),
              title: Text(user["displayName"],  style: Get.textTheme.titleSmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              subtitle: Text(user["email"]),
              onTap: () {
                Debug.log("Clicked user: ${user["id"]}");
              },
            );
          },
        );
      }),
    );
  }
}
