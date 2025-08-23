import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/app_spacing.dart';
import 'controller/create_group_detail_controller.dart';

class CreateGroupDetailScreen extends StatelessWidget {
  const CreateGroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateGroupDetailController controller = Get.put(CreateGroupDetailController());

    return Scaffold(
      appBar: AppBar(
        title: Text("New Group"),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.createGroup();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final groupId = FirebaseFirestore.instance.collection('groups').doc().id;
                    Get.bottomSheet(
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Take Photo"),
                              onTap: () {
                                controller.selectAndUploadGroupImage(
                                  groupId,
                                  fromCamera: true,
                                );
                                Get.back();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text("Choose from Gallery"),
                              onTap: () {
                                controller.selectAndUploadGroupImage(
                                  groupId,
                                  fromCamera: false,
                                );
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Obx(
                        () {
                      final image = controller.groupImage.value;
                      return CircleAvatar(
                        radius: 35,
                        backgroundImage: image != null
                            ? (image.startsWith('http')
                            ? NetworkImage(image)
                            : FileImage(File(image)) as ImageProvider)
                            : null,
                        child: image == null ? Icon(Icons.camera_alt, size: 30) : null,
                      );
                    },
                  ),
                ),
                widgetSpacerHorizontally(),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Group Name",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) => controller.groupName.value = val,
                  ),
                ),
              ],
            ),
            widgetSpacerVertically(),
            Text(
              "Participants",
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            otherSpacerVertically(),
            Obx(
                  () => controller.selectedMembers.isEmpty
                  ? Text("No members selected")
                  : Expanded(
                child: ListView.builder(
                  itemCount: controller.selectedMembers.length,
                  itemBuilder: (context, index) {
                    final member = controller.selectedMembers[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: member['image']!.isNotEmpty
                              ? NetworkImage(member['image']!)
                              : null,
                          child: member['image']!.isEmpty
                              ? Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          member['name']!,
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            sectionSmallSpacerVertically(),
            Obx(
                  () => controller.isLoading.value
                  ? LinearProgressIndicator()
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
