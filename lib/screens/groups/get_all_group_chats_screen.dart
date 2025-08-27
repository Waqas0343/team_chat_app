import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/app_constant_file/app_images.dart';
import '../../app_styles/app_constant_file/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/full_image.dart';
import 'controller/get_all_group_controller.dart';

class GetAllGroupChatsScreen extends StatelessWidget {
  const GetAllGroupChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetAllGroupController controller = Get.put(GetAllGroupController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Groups"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.groups.isEmpty) {
          return const Center(
            child: Text("No groups available"),
          );
        }

        return ListView.builder(
          itemCount: controller.groups.length,
          itemBuilder: (context, index) {
            final group = controller.groups[index];
            return ListTile(
              leading: GestureDetector(
                onTap: () {
                  Get.to(() =>  FullImageNetwork(
                    imagePath: group['image'],
                    tag: 'Pharmacy',
                  ),
                  );
                },
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: group['image'],
                    width: 60,
                    height: 60,
                    placeholder: (_, __) =>  Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => Image.asset(MyImages.logo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                group['name'],
                style: Get.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "${group['members']?.length ?? 0} members",
                style: Get.textTheme.titleSmall?.copyWith(
                    fontSize: 12, color: Colors.grey
                ),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.groupPersonChatsScreen, arguments: group);
              },
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.createNewGroupScreen);
        },
        backgroundColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
