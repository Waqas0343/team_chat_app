import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  

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
}