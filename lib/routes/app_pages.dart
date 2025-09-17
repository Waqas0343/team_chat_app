import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/calls/all_calls_list_user_screen.dart';
import '../screens/calls/call_screen.dart';
import '../screens/chats/chat_screen.dart';
import '../screens/groups/create_group_detail_screen.dart';
import '../screens/groups/create_new_group_screen.dart';
import '../screens/groups/get_all_group_chats_screen.dart';
import '../screens/groups/group_person_chats_screen.dart';
import '../screens/groups/group_profile_detail_screen.dart';
import '../screens/groups/select_member_for_group.dart';
import '../screens/home/home_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/users/all_app_user.dart';
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
      name: AppRoutes.getAllGroupChatsScreen,
      page: () =>  GetAllGroupChatsScreen(),
    ),
    GetPage(
      name: AppRoutes.chatScreen,
      page: () =>  ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.callsScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return CallScreen(
          callId: args['callId'] ?? "",
          isVideo: args['isVideo'] ?? false,
          userName: args['userName'] ?? "User",
        );
      },
    ),

    GetPage(
      name: AppRoutes.allAppUser,
      page: () =>  AllAppUser(),
    ),
    GetPage(
      name: AppRoutes.selectMemberForGroup,
      page: () =>  SelectMemberForGroup(),
    ),
    GetPage(
      name: AppRoutes.createGroupDetailScreen,
      page: () =>  CreateGroupDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.groupPersonChatsScreen,
      page: () =>  GroupPersonChatsScreen(),
    ),
    GetPage(
      name: AppRoutes.groupProfileDetailScreen,
      page: () =>  GroupProfileDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.getAllCallsListUsers,
      page: () =>  AllCallsListUserScreen(),
    ),
  ];


}
