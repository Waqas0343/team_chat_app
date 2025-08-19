import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_chat_app/app_styles/app_spacing.dart';
import '../../app_styles/app_constant_file/app_images.dart';
import 'controller/splash_controller.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  MyImages.logo,
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                widgetSpacerVertically(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nex", style: GoogleFonts.aDLaMDisplay(
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf16915),
                      ),
                    ),),
                    Text("Chat", style: GoogleFonts.aDLaMDisplay(
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023a84),

                      ),
                    ),),
                  ],
                ),
                widgetSpacerVertically(),
                if (controller.connectivityError.value)
                  Column(
                    children: [
                       Icon(
                        Icons.signal_wifi_off_outlined,
                        size: 60,
                      ),
                      otherSpacerVertically(),
                      Text(
                        "Internet Not available.",
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      sectionSmallSpacerVertically(),
                      ElevatedButton(
                        onPressed: () => controller.checkLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding:  EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                        ),
                        child:  Text(
                          "Retry",
                          style: Get.textTheme.titleSmall?.copyWith(
                              fontSize: 16.0
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
