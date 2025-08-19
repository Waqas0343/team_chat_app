import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant_file/app_colors.dart';

class AppThemeInfo {
  static double get borderRadius => 6.0;

  static ThemeData get themeData {
    var primaryColor =  MaterialColor(0xFF38BD88, {
      50: Color(0xffe5f9f1),
      100: Color(0xffb3eed7),
      200: Color(0xff80e3bd),
      300: Color(0xff4dd9a3),
      400: Color(0xff26d08a),
      500: Color(0xFF38BD88),
      600: Color(0xff34a678),
      700: Color(0xff2e8e67),
      800: Color(0xff297756),
      900: Color(0xff235f45),
    });
    var baseTheme = ThemeData(
      useMaterial3: false, // Disabling Material 3
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
        ),
        filled: false,
        fillColor: MyColors.fillColor,
        contentPadding:  EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              AppThemeInfo.borderRadius,
            ),
          ),
        ),
      ),
      cardTheme:  CardThemeData(
        elevation: 0,
      ),
      appBarTheme:  AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          padding:  EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MyColors.lightBlue,
          padding:  EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme:  FloatingActionButtonThemeData(
        backgroundColor: MyColors.accentColor,
        elevation: 2,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.lightBlue,
          padding:  EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          side:  BorderSide(color: MyColors.lightBlue),
          shape: RoundedRectangleBorder(
            side:  BorderSide(color: MyColors.lightBlue),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MyColors.primaryColor,
        selectionHandleColor: MyColors.primaryColor,
        selectionColor: MyColors.primaryColor.withValues(alpha: 0.5),
      ),
      tabBarTheme:  TabBarThemeData(
        labelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 16),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle:  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
        ),
      ),
      bottomAppBarTheme:  BottomAppBarThemeData(
        color: Colors.transparent,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return null;
              }
              if (states.contains(WidgetState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return null;
              }
              if (states.contains(WidgetState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return null;
              }
              if (states.contains(WidgetState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return null;
              }
              if (states.contains(WidgetState.selected)) {
                return MyColors.primaryColor;
              }
              return null;
            }),
      ),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        accentColor: MyColors.accentColor,
        backgroundColor: Colors.white,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.openSansTextTheme(baseTheme.textTheme),
    );
  }
}