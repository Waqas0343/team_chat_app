import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:team_chat_app/app_styles/app_constant_file/app_constant.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';
import 'package:team_chat_app/models/user_model.dart';

class AllAppUserController extends GetxController {
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var usersList = <UserModel>[].obs;
  var filteredList = <UserModel>[].obs;
  final RxBool isLoading = RxBool(false);

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

  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredList.value = List.from(usersList);
    } else {
      filteredList.value = usersList
          .where((user) =>
          user.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
}
