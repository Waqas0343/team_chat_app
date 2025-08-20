
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';
import '../../../app_styles/app_constant_file/app_constant.dart';
import '../../../models/user_model.dart';

class CreateGroupController extends GetxController {
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
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

  Future<String> getOrCreateChat(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(currentUserId, otherUserId);
    final chatDoc = _firestore.collection('chats').doc(chatId);

    try {
      await chatDoc.set({
        'participants': [currentUserId, otherUserId],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return chatId;
    } catch (e) {
      Debug.log("Error creating or fetching chat: $e");
      rethrow;
    }
  }

  String generateChatId(String currentUserId, String selectedUserId) {
    return currentUserId.compareTo(selectedUserId) < 0
        ? "${currentUserId}_$selectedUserId"
        : "${selectedUserId}_$currentUserId";
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
