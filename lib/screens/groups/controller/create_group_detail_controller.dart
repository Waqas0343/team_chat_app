import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_chat_app/routes/app_routes.dart';

class CreateGroupDetailController extends GetxController {
  var groupName = ''.obs;
  var groupImage = RxnString();
  var selectedMembers = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['members'] != null) {
      selectedMembers.value =
      List<Map<String, String>>.from(Get.arguments['members']);
    }
  }

  Future<File?> pickGroupImage({required bool fromCamera}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String?> uploadGroupImage(File file, String groupId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("group_images/$groupId/${DateTime.now().millisecondsSinceEpoch}.jpg");
      final snapshot = await ref.putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
      return null;
    }
  }

  Future<void> selectAndUploadGroupImage(String groupId,
      {required bool fromCamera}) async {
    File? file = await pickGroupImage(fromCamera: fromCamera);
    if (file != null) {
      String? url = await uploadGroupImage(file, groupId);
      if (url != null) {
        groupImage.value = url;
      }
    }
  }

  Future<void> createGroup() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (groupName.value.isEmpty) {
      Get.snackbar("Error", "Please enter group name");
      return;
    }
    if (selectedMembers.isEmpty && currentUserId == null) {
      Get.snackbar("Error", "Please select members");
      return;
    }

    try {
      isLoading.value = true;
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final groupId = FirebaseFirestore.instance.collection('groups').doc().id;

      final members = [
        ...selectedMembers.map((e) => e['id']),
        if (!selectedMembers.any((e) => e['id'] == currentUserId))
          currentUserId!,
      ];

      await FirebaseFirestore.instance.collection('groups').doc(groupId).set({
        'name': groupName.value,
        'members': members,
        'image': groupImage.value ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (Get.isDialogOpen == true) Get.back();

      Get.snackbar("Success", "Group Created Successfully");

      Get.offAllNamed(AppRoutes.getAllGroupChatsScreen);
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
