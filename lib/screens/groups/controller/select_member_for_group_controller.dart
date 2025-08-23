import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';

import '../../../app_styles/app_constant_file/app_constant.dart';
import '../../../models/user_model.dart';

class SelectMemberForGroupController extends GetxController{
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var usersList = <UserModel>[].obs;
  var filteredList = <UserModel>[].obs;
  final RxBool isLoading = RxBool(false);
  var selectedUsers = <Map<String, String>>[].obs;

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

  void toggleSelection(UserModel user) {
    final existing = selectedUsers.indexWhere((element) => element['id'] == user.id);
    if (existing >= 0) {
      selectedUsers.removeAt(existing);
    } else {
      selectedUsers.add({
        'id': user.id,
        'name': user.displayName,
        'image': user.photoUrl ?? ''
      });
    }
  }
}