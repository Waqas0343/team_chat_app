import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../models/message_model.dart';
import '../../../services/call_service.dart';

class ChatScreenController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isChatLoading = true.obs;

  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  String? chatId;
  String? receiverId;
  String? displayName;
  String? photoUrl;

  @override
  void onInit() async {
    super.onInit();
    var args = Get.arguments;
    chatId = args["chatId"];
    receiverId = args["userId"];
    displayName = args["displayName"];
    photoUrl = args["photoUrl"];

    await _initChat();   // Ensure chat exists
    _listenMessages();   // Start listening to messages
  }

  Future<void> _initChat() async {
    if (chatId == null) return;
    try {
      isChatLoading.value = true;

      final chatDoc = _firestore.collection('chats').doc(chatId);
      final docSnapshot = await chatDoc.get();

      if (!docSnapshot.exists) {
        // Create chat document if it doesn't exist
        await chatDoc.set({
          'participants': [currentUserId, receiverId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error initializing chat: $e");
    } finally {
      isChatLoading.value = false;
    }
  }

  void _listenMessages() {
    if (chatId == null) return;

    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => Message.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> sendTextMessage(String content) async {
    if (chatId == null) return;
    final message = Message(
      id: '',
      senderId: currentUserId,
      content: content,
      type: 'text',
      timestamp: DateTime.now(),
    );
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<String?> uploadImage() async {
    if (chatId == null) return null;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('chat_images/$fileName.jpg');
      await ref.putFile(file);
      String imageUrl = await ref.getDownloadURL();

      final message = Message(
        id: '',
        senderId: currentUserId,
        content: imageUrl,
        type: 'image',
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());
    }
    return null;
  }

  Future<String?> uploadVoice() async {
    if (chatId == null) return null;

    if (await Permission.microphone.request().isGranted) {
      // Voice recording logic (uncomment and implement if needed)
      // final recorder = Record();
      // String filePath = 'voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      // await recorder.start(path: filePath);
      // await Future.delayed(Duration(seconds: 10));
      // await recorder.stop();
      // File file = File(filePath);
      // Reference ref = storage.ref().child('chat_voices/$filePath');
      // await ref.putFile(file);
      // return await ref.getDownloadURL();
    }
    return null;
  }

  Future<void> startCall() async {
    if (receiverId == null) return;
    final callId = await CallService().startCall(receiverId!);
    if (callId.isNotEmpty) {
      Get.toNamed('/call', arguments: {'callId': callId});
    }
  }
}
