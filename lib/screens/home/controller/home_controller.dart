import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var chats = <Map<String, dynamic>>[].obs;
  var filteredChats = <Map<String, dynamic>>[].obs;
  final RxInt selectedIndex = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAllUserChats();
  }

  void getAllUserChats() {
    String currentUserId = auth.currentUser!.uid;
    isLoading.value = true;

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
          // Get last message
          QuerySnapshot lastMsgSnapshot = await _firestore
              .collection('chats')
              .doc(doc.id)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          String lastMessage = '';
          DateTime? lastMsgTime;

          if (lastMsgSnapshot.docs.isNotEmpty) {
            var msgData = lastMsgSnapshot.docs.first.data() as Map<String, dynamic>;
            lastMessage = msgData['content'];
            lastMsgTime = (msgData['timestamp'] as Timestamp).toDate();
          }

          chatList.add({
            "chatId": doc.id,
            "userId": otherUserId,
            "displayName": userDoc['displayName'],
            "email": userDoc['email'],
            "photoUrl": userDoc['photoUrl'] ?? "",
            "lastMessage": lastMessage,
            "lastMessageTime": lastMsgTime,
          });
        }
      }

      chats.value = chatList;
      filteredChats.value = chatList;
      isLoading.value = false;
    });
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      filteredChats.value = chats;
    } else {
      filteredChats.value = chats
          .where((chat) =>
      chat['displayName'].toLowerCase().contains(query.toLowerCase()) ||
          chat['email'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
  final List<IconData> icons = [ Icons.message, Icons.group, Icons.call, Icons.supervisor_account_rounded, ]; final List<String> labels = [ 'Chats', 'Groups', 'Calls', 'Users', ];
  void changeTab(int index) {
    selectedIndex.value = index;
    Get.toNamed([
      AppRoutes.homeScreen,
      AppRoutes.getAllGroupChatsScreen,
      AppRoutes.getAllCallsListUsers,
      AppRoutes.allAppUser,
    ][index]);
  }
}

