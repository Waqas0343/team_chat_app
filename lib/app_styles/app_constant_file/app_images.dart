
import 'package:flutter/services.dart';

class MyImages{
  static const logo = "assets/images/logo.png";
  static const loadingGif = "assets/images/loading.gif";


  static Future<Uint8List> getImageBytes(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }
}