import 'package:get/get_navigation/src/routes/get_route.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/calls/call_screen.dart';
import '../screens/chats/chat_screen.dart';
import '../screens/groups/create_new_group_screen.dart';
import '../screens/groups/group_chats_screen.dart';
import '../screens/home/home_screen.dart';
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
    GetPage(
      name: AppRoutes.homeScreen,
      page: () =>  HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.createNewGroupScreen,
      page: () =>  CreateNewGroupScreen(),
    ),

    GetPage(
      name: AppRoutes.groupChatScreen,
      page: () =>  GroupChatsScreen(),
    ),
    GetPage(
      name: AppRoutes.chatScreen,
      page: () =>  ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.callsScreen,
      page: () =>  CallScreen(),
    ),

  ];


}
