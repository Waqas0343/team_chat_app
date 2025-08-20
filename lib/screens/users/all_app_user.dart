import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/routes/app_routes.dart';
import '../../app_styles/app_constant_file/app_colors.dart';
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
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search Users',
                prefixIcon:  Icon(Icons.search),
                suffixIcon: Obx(() => (controller.filteredList.isNotEmpty &&
                    controller.filteredList.length != controller.usersList.length)
                    ? IconButton(
                  icon:  Icon(Icons.clear),
                  onPressed: () {
                    controller.searchUsers('');
                  },
                )
                    :  SizedBox.shrink()),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: MyColors.primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
              onChanged: controller.searchUsers,
            ),

          ),
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
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? const Icon(Icons.person)
                          : null,
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
                    onTap: () async {
                      final chatId = await controller.getOrCreateChat(user.id);
                      Get.toNamed(AppRoutes.chatScreen, arguments: {
                        "chatId": chatId,
                        "userId": user.id,
                        "displayName": user.displayName,
                        "photoUrl": user.photoUrl,
                      });
                    },

                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}


