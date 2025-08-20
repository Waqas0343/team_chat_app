import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_chat_app/app_styles/app_constant_file/app_colors.dart';
import 'controller/auth_screen_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthScreenController controller = Get.put(AuthScreenController());

    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome Back!",
                  style: Get.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Sign in to continue",
                  style: Get.textTheme.titleSmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      controller.signInWithGoogle();
                    },
                    icon: Icon(
                      Icons.email_outlined,
                      size: 24,
                      color: Colors.red,
                    ),
                    label: Text(
                      "Sign in with Google",
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Your security is our priority 🔒",
                  style: Get.textTheme.titleSmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Loading Spinner Overlay
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
