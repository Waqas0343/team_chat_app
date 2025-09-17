
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_chat_app/app_styles/helper/app_debug_pointer.dart';

import '../app_constant_file/app_constant.dart';

class Preferences extends GetxService {
  late SharedPreferences _preferences;

  Future<Preferences> initial() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future setString(String key, String? value) async {
    if (value == null) return;
    try {
      await _preferences.setString(key, value);
    } catch (e) {
      Debug.log("$e");
    }
  }

  Future setInt(String key, int? value) async {
    if (value == null) return;
    try {
      await _preferences.setInt(key, value);
    } catch (e) {
      Debug.log("$e");
    }
  }

  Future setBool(String key, bool? value) async {
    if (value == null) return;
    try {
      await _preferences.setBool(key, value);
    } catch (e) {
      Debug.log("$e");
    }
  }

  String? getString(String key) {
    try {
      return _preferences.getString(key);
    } catch (e) {
      Debug.log("$e");
    }

    return "";
  }

  int? getInt(String key) {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      Debug.log("$e");
    }
    return 0;
  }

  bool? getBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (e) {
      Debug.log("$e");
    }
    return null;
  }

  Future clear() async {
    await _preferences.clear();
  }
  Future remove(String key) async {
    try {
      await _preferences.remove(key);
    } catch (e) {
      Debug.log("$e");
    }
  }


  Future<void> logout() async {
    await Get.find<Preferences>().clear();
    Get.find<Preferences>().setBool(Keys.isFirstTime, false);
    // Get.offAllNamed(AppRoutes.loginScreen);
  }
}