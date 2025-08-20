import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_styles/app_constant_file/app_constant.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var chats = [].obs; // List of chats with user info
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserChats();
  }

  void fetchUserChats() {
    String currentUserId = auth.currentUser!.uid;
    _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> chatList = [];

      for (var doc in snapshot.docs) {
        List participants = doc['participants'];
        String otherUserId =
        participants.firstWhere((id) => id != currentUserId);
        var userDoc =
        await _firestore.collection('users').doc(otherUserId).get();

        if (userDoc.exists) {
          chatList.add({
            "chatId": doc.id,
            "userId": otherUserId,
            "displayName": userDoc['displayName'],
            "email": userDoc['email'],
            "photoUrl": userDoc['photoUrl'] ?? "",
          });
        }
      }

      chats.value = chatList;
    });
  }
  final List<String> pageRoutes = [
    AppRoutes.homeScreen,
    AppRoutes.createNewGroupScreen,
    AppRoutes.callsScreen,
    AppRoutes.allAppUser,
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
