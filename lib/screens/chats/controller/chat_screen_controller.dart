import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../models/message_model.dart';
import '../../../services/call_service.dart';
import '../../../services/chat_service.dart';
import '../../../services/storage_service.dart';

class ChatScreenController extends GetxController {
    String? chatId;
    String? receiverId;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ChatService _chatService = ChatService();
  final RxList<Message> messages = <Message>[].obs;

  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    // _listenMessages();
  }

  void _listenMessages() {
    _chatService.getMessages(chatId!).listen((msgList) {
      messages.assignAll(msgList.reversed.toList()); // reverse to show latest at bottom
    });
  }

  void sendTextMessage(String content) {
    final message = Message(
      id: '',
      senderId: currentUserId,
      content: content,
      type: 'text',
      timestamp: DateTime.now(),
    );
    _chatService.sendMessage(chatId!, message);
  }

  Future<String?> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('chat_images/$fileName.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
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
