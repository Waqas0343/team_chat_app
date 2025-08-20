import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_styles/app_constant_file/app_constant.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  var users = <DocumentSnapshot>[].obs;
  var groups = <DocumentSnapshot>[].obs;
  RxInt selectedIndex = 0.obs;


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

  final List<String> pageRoutes = [
    AppRoutes.homeScreen,
    AppRoutes.createNewGroupScreen,
    AppRoutes.callsScreen,
    AppRoutes.groupChatScreen,
  ];

  final List<IconData> icons = [
    Icons.message,
    Icons.group,
    Icons.call,
    Icons.supervisor_account_rounded,
  ];

  final List<String> labels = [
    'Chats',
    'Groups',
    'Calls',
    'Users',
  ];
  void changeTab(int index) {
    selectedIndex.value = index;
    Get.toNamed(pageRoutes[index]);
  }
}
