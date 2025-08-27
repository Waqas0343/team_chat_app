import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';

class GroupProfileDetailController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> membersList = <Map<String, dynamic>>[].obs;

  late String groupId;
  late String groupName;
  late String groupImage;
  late String createdBy;
  late List<dynamic> members;

  @override
  void onInit() {
    final args = Get.arguments;
    groupId = args["id"];
    groupName = args["name"];
    groupImage = args["image"];
    createdBy = args["createdBy"];
    members = args["members"];

    fetchGroupMembers();
    super.onInit();
  }
  void fetchGroupMembers() async {
    try {
      isLoading.value = true;
      Debug.log("Fetching members: $members");

      final usersSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where(FieldPath.documentId, whereIn: members)
          .get();

      for (var doc in usersSnapshot.docs) {
        Debug.log("User Doc => ${doc.id} : ${doc.data()}");
      }

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

}
