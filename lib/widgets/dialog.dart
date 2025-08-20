import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_styles/app_constant_file/app_images.dart';
import '../../app_styles/app_custom_fonts.dart';
import '../app_styles/app_spacing.dart';
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      content: Row(
        children: [
          Image.asset(MyImages.loadingGif, height: 60, ),
          widgetSpacerHorizontally(),
          Text(
            "Please Wait...",
            style: Get.textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontFamily: CustomFonts.roboto,
              fontWeight: FontWeight.w700,
            )
          )
        ],
      ),
    );
  }
}
