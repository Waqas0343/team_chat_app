import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/group_profile_detail_controller.dart';

class GroupProfileDetailScreen extends StatelessWidget {
   GroupProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupProfileDetailController controller = Get.put(GroupProfileDetailController());

    return Scaffold(
      appBar: AppBar(
        title:  Text("Group Info"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: controller.groupImage.isNotEmpty
                    ? CachedNetworkImageProvider(controller.groupImage)
                    : null,
                backgroundColor: Colors.grey[300],
                child: controller.groupImage.isEmpty
                    ?  Icon(Icons.group, size: 50, color: Colors.white)
                    : null,
              ),
               SizedBox(height: 12),
              Text(
                controller.groupName,
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: 8),
              Text(
                "Created by: ${controller.createdBy}",
                style:  TextStyle(color: Colors.grey),
              ),
              Divider(),
              ListTile(
                title: Text(
                  "${controller.membersList.length} Members",
                  style:  TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                itemCount: controller.membersList.length,
                shrinkWrap: true,
                physics:  NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final member = controller.membersList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: member["image"].isNotEmpty
                          ? CachedNetworkImageProvider(member["image"])
                          : null,
                      child: member["image"].isEmpty
                          ?  Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(member["name"]),
                    subtitle: Text(member["email"]),
                    trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete_outlined, color: Colors.red,)),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
