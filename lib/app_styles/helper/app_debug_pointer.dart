import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;

class Debug {
  static log(dynamic value) {
    if (foundation.kDebugMode) {
      Get.log("$value");
    }
  }
}