import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:team_chat_app/app_styles/app_spacing.dart';
import 'package:team_chat_app/routes/app_routes.dart';
import '../../app_styles/app_constant_file/app_colors.dart';
import '../../app_styles/app_constant_file/app_images.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white,
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
              if (controller.chats.isEmpty) {
                return Center(child: Text('No chats found'));
              }
              return ListView.builder(
                itemCount: controller.chats.length,
                itemBuilder: (ctx, index) {
                  final chat = controller.chats[index];
                  return ListTile(
                    leading: ClipOval(
                      child: chat['photoUrl'] != ""
                          ? Image.network(chat['photoUrl'])
                          : Icon(Icons.person, size: 40),
                    ),
                    title: Text(
                      chat['displayName'],
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(chat['email']),
                    onTap: () {
                      Get.toNamed(AppRoutes.chatScreen, arguments: {
                        "chatId": chat["chatId"],
                        "userId": chat["userId"],
                        "displayName": chat["displayName"],
                        "photoUrl": chat["photoUrl"],
                      });
                    },
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
          // Get.toNamed(AppRoutes.chatScreen);
        },
        backgroundColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), // #f16915
        child:  Icon(
          Icons.group_add,
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.selectedIndex.value,
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: controller.changeTab,
        items: List.generate(controller.icons.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              children: [
                Container(
                  height: 3,
                  width: 30,
                  margin: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color:
                    controller.selectedIndex.value == index
                        ? MyColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Icon(controller.icons[index]),
              ],
            ),
            label: controller.labels[index],
          );
        }),
      ),
    );
  }
}
