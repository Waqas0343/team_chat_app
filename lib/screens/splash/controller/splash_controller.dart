import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
    await 3.0.delay();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      Get.offAllNamed(AppRoutes.loginWithMail);
    }
  }
}