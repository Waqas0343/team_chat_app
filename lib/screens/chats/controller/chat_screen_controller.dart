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
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  String? chatId;
  String? receiverId;
  String? displayName;
  String? photoUrl;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    chatId = args["chatId"];
    receiverId = args["userId"];
    displayName = args["displayName"];
    photoUrl = args["photoUrl"];
    listenMessages();
  }

  void listenMessages() {
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

  Future<void>  sendTextMessage(String content) async {
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

  Future<String?>  uploadImage() async {
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
    if (await Permission.microphone.request().isGranted) {
      // final recorder = Record();
      // String filePath = 'voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      // await recorder.start(path: filePath);
      // await Future.delayed(Duration(seconds: 10));
      // await recorder.stop();
      // File file = File(filePath);
      // Reference ref = _storage.ref().child('chat_voices/$filePath');
      // await ref.putFile(file);
      // return await ref.getDownloadURL();
    }
    return null;
  }


  Future<void> startCall() async {
    final callId = await CallService().startCall(receiverId!);
    if (callId.isNotEmpty) {
      Get.toNamed('/call', arguments: {'callId': callId});
    }
  }
}
