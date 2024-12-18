import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/Login_Page.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/images.dart';
import 'package:iw_admin_panel/controllers/chat_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import 'package:iw_admin_panel/widgets/dashboard_widget.dart';

class MainDashboard extends StatefulWidget {
  final bool isDrawer;

  const MainDashboard({super.key, required this.isDrawer});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  final SidebarController controller = Get.put(SidebarController());
  final ChatController chatVM = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    double calculatedWith(double width) {
      if (width <= 425) return width * 0.2;
      if (width <= 768 && width > 425) return width * 0.4;
      if (width <= 1024 && width > 768) return width * 0.23;
      if (width <= 1520 && width > 1024) return width * 0.22;
      if (width <= 2900 && width > 1520) return width * 0.2;
      return Get.width * 0.5;
    }

    double calculatedHeight(double width) {
      if (width <= 430 && width > 300) return 25;
      if (width <= 768 && width > 425) return 30;
      if (width <= 1024 && width > 768) return 60;
      if (width <= 1520 && width > 1024) return  35;
      if (width <= 2900 && width > 1520) return 40;
      return Get.width * 0.5;
    }



    return Obx(
      ()=> Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: calculatedWith(width),
        height: Get.height,
        color: AppColors.blueColor,
        child: Column(
          children: [
            SizedBox(height:  calculatedHeight(width),),
            Image.asset(AppImages.quanderyLogo, height: 90, width: 90,),
            SizedBox(height: calculatedHeight(width),),
            DashboardWidget(
                title: "Users",
                subTitle: "Users",
                onPressed: (){
                  controller.selectedTab.value = "Users";
                  controller.chat.value = false;
                  if(widget.isDrawer == true){
                    Get.back();
                  }
                  },
                iconData: Icons.person,
                isSelected: controller.selectedTab.value == "Users" ? true : false,
                isDrawer: widget.isDrawer,
            ),
            DashboardWidget(
              title: "Add Users",
              subTitle: "Add Users",
              onPressed: (){
                controller.selectedTab.value = "Add Users";
                controller.chat.value = false;
                if(widget.isDrawer == true){
                  Get.back();
                }
              },
              iconData: Icons.person,
              isSelected: controller.selectedTab.value == "Add Users" ? true : false,
              isDrawer: widget.isDrawer,
            ),
            DashboardWidget(
                title: "Add Event",
                subTitle: "Add Event",
                onPressed: (){
                  controller.selectedTab.value = "Add Event";
                  controller.chat.value = false;
                  if(widget.isDrawer == true){
                    Get.back();
                  }                },
                iconData: Icons.event,
                isSelected: controller.selectedTab.value == "Add Event" ? true : false,
                isDrawer: widget.isDrawer,
            ),
            DashboardWidget(
                title: "Edit Event",
                subTitle: "Edit Event",
                onPressed: (){
                  controller.selectedTab.value = "Edit Event";
                  controller.chat.value = false;
                  if(widget.isDrawer == true){
                    Get.back();
                  }                },
                iconData: Icons.event,
                isSelected: controller.selectedTab.value == "Edit Event" ? true : false,
                isDrawer: widget.isDrawer,
            ),
            DashboardWidget(
                title: "Online Support",
                subTitle: "Online Support",
                onPressed: (){
                  controller.selectedTab.value = "Online Support";
                  controller.chat.value = true;
                  chatVM.user_id.value = "";
                  if(widget.isDrawer == true){
                    Get.back();
                  }
                },
                iconData: Icons.chat_bubble,
                isSelected: controller.selectedTab.value == "Online Support" ? true : false,
                isDrawer: widget.isDrawer,
            ),
            if(widget.isDrawer == false)
            DashboardWidget(
                title: "Log out",
                subTitle: "Log out",
                onPressed: () async{
                await  FirebaseAuth.instance.signOut();
                  Get.offAll(LoginPage());
                },
                iconData: Icons.logout,
                isSelected: controller.selectedTab.value == "Log out" ? true : false,
                isDrawer: widget.isDrawer,
            ),
          ],
        ),
      ),
    );
  }
}
