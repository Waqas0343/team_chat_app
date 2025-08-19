import 'dart:async';
import 'package:get/get.dart';
import '../app_styles/helper/app_perferences.dart';

class Services {
  static final Services _instance = Services._();
  Services._();

  factory Services() => _instance;

  Future<void> initServices() async {
    await Get.putAsync<Preferences>(() => Preferences().initial());
  }
}
