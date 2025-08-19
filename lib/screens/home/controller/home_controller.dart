import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var users = <DocumentSnapshot>[].obs;
  var groups = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchGroups();
  }

  void fetchUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      users.value = snapshot.docs;
    });
  }

  void fetchGroups() {
    FirebaseFirestore.instance.collection('groups').snapshots().listen((snapshot) {
      groups.value = snapshot.docs;
    });
  }
}
