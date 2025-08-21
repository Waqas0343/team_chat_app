import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupDetailController extends GetxController{
  var groupName = ''.obs;
  var groupImage = RxnString();
  var selectedMembers = <Map<String, String>>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickGroupImage({required bool fromCamera}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70, // compress for performance
    );
    if (pickedFile != null) {
      groupImage.value = pickedFile.path;
    }
  }

  void createGroup() {
    if (groupName.isEmpty) {
      Get.snackbar("Error", "Please enter group name");
      return;
    }
    if (selectedMembers.isEmpty) {
      Get.snackbar("Error", "Please select members");
      return;
    }

    // TODO: Send groupImage, groupName, selectedMembers to API
    Get.snackbar("Success", "Group Created Successfully");
  }
}