import 'package:get/get.dart';

import '../../../app_styles/app_constant_file/app_constant.dart';
import '../../../app_styles/helper/app_perferences.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final RxBool connectivityError = RxBool(false);
  final RxBool buttonAction = RxBool(true);
  final RxBool isLoading = RxBool(true);
  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    connectivityError(false);
    bool status = Get.find<Preferences>().getBool(Keys.status) ?? false;
    await 3.0.delay();
    if (status) {
      Get.offNamed(AppRoutes.loginWithMail);
    } else {
      Get.offNamed(AppRoutes.loginWithMail);
    }
  }


}