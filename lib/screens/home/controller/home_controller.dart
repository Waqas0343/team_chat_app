import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_styles/app_constant_file/app_constant.dart';

class HomeController extends GetxController {
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
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
