import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../home_screen.dart';

class AuthScreenController extends GetxController {
  final AuthService _authService = AuthService();

  // Google Sign In
  Future<void> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      // Navigate to HomeScreen using GetX
      Get.off(() => HomeScreen());
    }
  }
}
