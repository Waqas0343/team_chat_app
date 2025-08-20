import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    onTap: () async {

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
      ),
    );
  }
}
