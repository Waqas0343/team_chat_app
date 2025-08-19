import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../services/chat_service.dart';

class CreateGroupController extends GetxController {
  final ChatService _chatService = ChatService();
  var allUsers = <UserModel>[].obs;
  var selectedUserIds = <String>[].obs;
  var groupName = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    isLoading.value = true;
    // allUsers.value = await _chatService.getAllUsers();
    isLoading.value = false;
  }

  void toggleUserSelection(String userId) {
    if (selectedUserIds.contains(userId)) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
  }

  Future<void> createGroup() async {
    if (groupName.isEmpty || selectedUserIds.isEmpty) return;
    await _chatService.createGroup(groupName.value, selectedUserIds);
    Get.back(); // go back after creation
  }
}
