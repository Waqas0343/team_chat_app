import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AllAppUserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var usersList = [].obs;
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection("users").get();
      usersList.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "email": doc["email"] ?? "",
          "displayName": doc["displayName"] ?? "",
          "fcmToken": doc["fcmToken"] ?? "",
          "photoUrl": doc["photoUrl"] ?? "",
        };
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
