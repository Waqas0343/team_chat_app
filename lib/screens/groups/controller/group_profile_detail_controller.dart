import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupProfileDetailController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> membersList = <Map<String, dynamic>>[].obs;

  final RxString createdByName = "".obs;
  final RxString createdByImage = "".obs;

  late String groupId;
  late String groupName;
  late String groupImage;
  late String createdBy;
  late List<dynamic> members;

  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void onInit() {
    final args = Get.arguments;
    groupId = args["id"];
    groupName = args["name"];
    groupImage = args["image"];
    createdBy = args["createdBy"];
    members = args["members"];

    fetchGroupMembers();
    fetchCreatedByUser();
    super.onInit();
  }

  void fetchCreatedByUser() async {
    try {
      final doc =
      await FirebaseFirestore.instance.collection("users").doc(createdBy).get();
      if (doc.exists) {
        final data = doc.data()!;
        createdByName.value = data["name"] ?? data["displayName"] ?? "Unknown";
        createdByImage.value = data["image"] ?? data["photoUrl"] ?? "";
      } else {
        createdByName.value = "Unknown";
      }
    } catch (e) {
      Debug.log("Error fetching createdBy: $e");
      createdByName.value = "Unknown";
    }
  }

  void fetchGroupMembers() async {
    try {
      isLoading.value = true;
      Debug.log("Fetching members: $members");

      final usersSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where(FieldPath.documentId, whereIn: members)
          .get();

      membersList.value = usersSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "name": data["name"] ?? data["displayName"] ?? "Unknown",
          "image": data["image"] ?? data["photoUrl"] ?? "",
          "email": data["email"] ?? data["emailAddress"] ?? "",
        };
      }).toList();
    } catch (e) {
      Debug.log("Error fetching members: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMember(String memberId) async {
    if (currentUserId != createdBy) {
      Get.snackbar("Permission Denied", "Only the group creator can remove members.");
      return;
    }
    try {
      await FirebaseFirestore.instance.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayRemove([memberId]),
      });
      membersList.removeWhere((member) => member["id"] == memberId);
      Get.snackbar("Success", "Member removed successfully.");
    } catch (e) {
      Debug.log("Error removing member: $e");
      Get.snackbar("Error", "Failed to remove member.");
    }
  }
}
