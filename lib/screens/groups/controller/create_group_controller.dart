import 'dart:developer' as Debug;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_styles/app_constant_file/app_constant.dart';
import '../../../models/user_model.dart';
import '../../../services/chat_service.dart';

class CreateGroupController extends GetxController {
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var usersList = <UserModel>[].obs;
  var filteredList = <UserModel>[].obs;
  final RxBool isLoading = RxBool(false);
  var groupName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllRegisterUsers();
  }

  Future<void> getAllRegisterUsers() async {
    try {
      isLoading.value = true;
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final snapshot = await _firestore.collection("users").get();
      usersList.value = snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();

      filteredList.value = List.from(usersList);
    } catch (e) {
      Debug.log("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // void toggleUserSelection(String userId) {
  //   if (selectedUserIds.contains(userId)) {
  //     selectedUserIds.remove(userId);
  //   } else {
  //     selectedUserIds.add(userId);
  //   }
  // }

  // Future<void> createGroup() async {
  //   if (groupName.isEmpty || selectedUserIds.isEmpty) return;
  //   await _chatService.createGroup(groupName.value, selectedUserIds);
  //   Get.back(); // go back after creation
  // }
}
