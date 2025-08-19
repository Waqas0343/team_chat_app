import 'package:get/get_navigation/src/routes/get_route.dart';
import '../screens/auth_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () =>  Splash(),
    ),
    GetPage(
      name: AppRoutes.loginWithMail,
      page: () =>  AuthScreen(),
    ),

  ];


}
