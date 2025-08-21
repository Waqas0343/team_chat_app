import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/create_group_detail_controller.dart';

class CreateGroupDetailScreen extends StatelessWidget {
  const CreateGroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateGroupDetailController controller = Get.put(CreateGroupDetailController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Group"),
        actions: [
          IconButton(
            onPressed: () => controller.createGroup(),
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Group Image + Group Name
            Row(
              children: [
                Obx(() => GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16)),
                        ),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Take Photo"),
                              onTap: () {
                                controller.pickGroupImage(fromCamera: true);
                                Get.back();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Choose from Gallery"),
                              onTap: () {
                                controller.pickGroupImage(fromCamera: false);
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: controller.groupImage.value != null
                        ? FileImage(File(controller.groupImage.value!))
                        : null,
                    child: controller.groupImage.value == null
                        ? const Icon(Icons.camera_alt, size: 30)
                        : null,
                  ),
                )),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Group Subject",
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (val) => controller.groupName.value = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Participants"),
            ),
            const SizedBox(height: 10),
            // Selected Members List
            Obx(() => controller.selectedMembers.isEmpty
                ? const Text("No members selected")
                : SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedMembers.length,
                itemBuilder: (context, index) {
                  final member = controller.selectedMembers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(member['image']!),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          member['name']!,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
