import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/Login_Page.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/controllers/chat_controller.dart';

import 'package:iw_admin_panel/sidebar_controller.dart';
import 'package:iw_admin_panel/tab_pages/add_users.dart';
import 'package:iw_admin_panel/tab_pages/edit_events.dart';
import 'package:iw_admin_panel/tab_pages/online_support.dart';
import 'package:iw_admin_panel/tab_pages/read.dart';
import 'package:iw_admin_panel/tab_pages/user_details.dart';
import 'package:iw_admin_panel/widgets/custom_buuton.dart';
import 'package:iw_admin_panel/widgets/main_dashboard.dart';
import 'package:iw_admin_panel/widgets/online_support_widget.dart';

import 'const/textstyle.dart';
import 'tab_pages/add_events.dart';
import 'home_main_admin.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final SidebarController sidebarController = Get.put(SidebarController());
  final UserController userVM = Get.put(UserController());
  final ChatController chatVM = Get.put(ChatController());


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double calculatedWith(double width) {
      if (width <= 425) return width * 0.6;
      if (width <= 768 && width > 425) return width * 0.6;
      return Get.width * 0.5;
    }

    return Scaffold(
      drawer: width <= 768
          ? Obx(
        ()=> Drawer(
                    width: width <= 768 && width > 425 ? 340 : 280,
                    backgroundColor: AppColors.blueColor,
                    child: sidebarController.selectedDrawer.value == "Simple" ? Padding(
                      padding: EdgeInsets.all(14.0),
                      child: MainDashboard(isDrawer: true,),
                    ) : chatDrawer(),
                  ),
          )
          : null,
      appBar: width <= 768 ? AppBar(
        backgroundColor: AppColors.blueColor, // Customize your AppBar color
        elevation: 0,
        leadingWidth: 100,
        leading: Obx(
          ()=> Row(
            children: [
              SizedBox(width: 15,),
              Builder(
                builder: (context) => InkWell(
                  child: Icon(Icons.menu, size: 30, color: Colors.white),
                  onTap: () {
                    sidebarController.selectedDrawer.value = "Simple";
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              SizedBox(width: 15,),
              if(sidebarController.chat.value == true && width <= 600)
              Builder(
                builder: (context) => InkWell(
                  child: Icon(Icons.chat, size: 30, color: Colors.white),
                  onTap: () {
                    sidebarController.selectedDrawer.value = "Chat";
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CustomButton(
              text: "Logout",
              width: 80,
              height: 25,
              color: AppColors.secondaryColor,
              textColor: AppColors.blueColor,
              fontSize: 13,
              margin_bottom: 0,
              borderRadius: 7,
              fontWeight: FontWeight.w600,
              onPressed: () async{
                await  FirebaseAuth.instance.signOut();
                Get.offAll(LoginPage());
              },
            ),
          ),
        ],
      ) : null,
      body: GestureDetector(
        onTap: () {
          if (sidebarController.showsidebar.value == true) {
            sidebarController.showsidebar.value = false;
          }
        },
        child: Row(
          children: [
            width > 768 ? MainDashboard(isDrawer: false,) : SizedBox.shrink(),
            Expanded(
              child: Obx(
                    () => sidebarController.selectedTab.value == "Users"
                    ? UserDetails()
                    : sidebarController.selectedTab.value == "Add Users"
                    ? AddUsers()
                    : sidebarController.selectedTab.value == "Add Event"
                    ? AddEvents()
                    : sidebarController.selectedTab.value == "Edit Event"
                    ? EditEvents()
                    : sidebarController.selectedTab.value == "Online Support"
                    ? OnlineSupport()
                    : LoginPage()
              ),
            ),
          ],
        ),
      ),
    );

  }

  double userWidgetWidth(double width) {
    if (width <= 430) return width * 0.25;
    if (width <= 768) return width * 0.25;
    return Get.width * 0.2;
  }

  Widget chatDrawer()  {

    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection(
                "online_support").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: Get.height * .4),
                  child: SizedBox(
                    width: userWidgetWidth(width),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.whiteColor),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint(
                    "Error in events stream home page: ${snapshot
                        .error}");
                return Center(
                  child: Text(
                    "An Error occurred",
                    style: jost500(16, AppColors.blueColor),
                  ),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "There are no chat at the moment",
                    style: jost500(16, AppColors.blueColor),
                  ),
                );
              } else if (snapshot.connectionState ==
                  ConnectionState.none) {
                return Center(
                  child: Text(
                    "No Internet!",
                    style: jost500(16, AppColors.blueColor),
                  ),
                );
              } else {
                var onlineSupporters = snapshot.data!.docs;
                debugPrint("${onlineSupporters}");

                return Center(
                  child: SizedBox(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      itemCount: onlineSupporters.length,
                      itemBuilder: (context, index) {
                        // Extract the user UID
                        var uid = onlineSupporters[index]['uid'];

                        // Fetch the user data based on the UID using FutureBuilder
                        return FutureBuilder<
                            DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot
                                .connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox();
                            } else
                            if (userSnapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10.0),
                                child: Center(
                                  child: Text(
                                      "Error loading user data",
                                      style: jost500(16,
                                          AppColors
                                              .blueColor)),
                                ),
                              );
                            } else
                            if (!userSnapshot.hasData ||
                                !userSnapshot.data!.exists) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10.0),
                                child: Center(
                                  child: Text(
                                      "User not found",
                                      style: jost500(16,
                                          AppColors
                                              .blueColor)),
                                ),
                              );
                            } else {
                              // Access user data
                              var user = userSnapshot.data!;
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10.0),
                                child: InkWell(
                                  autofocus: false,
                                  onTap: () {
                                    chatVM.user_id.value = user['uid'];
                                    print(chatVM.user_id.value);
                                    Get.back();
                                  },
                                  child: OnlineSupportWidget(
                                    profile_type: user['profile_type'],
                                    profile_pic: user['profile_pic'],
                                    name: user['name'],
                                    email: user['email'],
                                    is_verified: user['is_verified'],
                                    bio: user['bio'],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
