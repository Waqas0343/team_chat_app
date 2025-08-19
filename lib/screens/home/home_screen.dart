import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_chat_app/app_styles/app_spacing.dart';
import 'package:team_chat_app/routes/app_routes.dart';
import 'package:team_chat_app/widgets/custom_card_widget.dart';
import '../../app_styles/app_constant_file/app_colors.dart';
import '../../app_styles/app_constant_file/app_images.dart';
import '../../services/auth_service.dart';
import 'controller/home_controller.dart';
import '../../widgets/group_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding:  EdgeInsets.only(top: 6.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.asset(
                  MyImages.logo,
                  color: Colors.white,
                  height: 30,
                ),
                widgetSpacerHorizontally(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nex", style: GoogleFonts.aDLaMDisplay(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf16915),
                      ),
                    ),),
                    Text("Chat", style: GoogleFonts.aDLaMDisplay(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),),
                  ],
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding:  EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon:  Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                  },
                ),
                PopupMenuButton<String>(
                  icon:  Icon(
                    Icons.more_vert_outlined,
                    color: MyColors.primaryColor,
                    size: 30,
                  ),
                  onSelected: (value) {},
                  itemBuilder: (BuildContext context) {
                    return  [
                      PopupMenuItem<String>(
                        value: 'Youtube',
                        child: Row(
                          children: [
                            // Icon(FontAwesomeIcons.youtube, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Youtube'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.users.isEmpty) {
                return Center(child: Text('No users found'));
              }
              return ListView.builder(
                padding:  EdgeInsets.all(8.0),
                itemCount: controller.users.length,
                itemBuilder: (ctx, index) {
                  final user = controller.users[index];
                  return Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: CustomCard(
                      onPressed: (){},
                      child: ListTile(
                        leading: ClipOval(
                          child: Image.network(user['photoUrl']),
                        ),
                        title: Text(user['displayName'], style: Get.textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                        subtitle: Text(user['email']),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (controller.groups.isEmpty) {
                return Center(child: Text('No groups found'));
              }
              return ListView.builder(
                itemCount: controller.groups.length,
                itemBuilder: (ctx, index) {
                  final group = controller.groups[index];
                  return GroupTile(
                    groupId: group.id,
                    groupName: group['name'],
                    onTap: (){
                      Get.toNamed(AppRoutes.groupChatScreen, arguments:  group.id);
                    }

                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.createNewGroupScreen);
        },
        backgroundColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), // #f16915
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
        onTap: (index) {
          if (index == 1) {
           Get.toNamed(AppRoutes.createNewGroupScreen);
          }
        },
      ),
    );
  }
}
