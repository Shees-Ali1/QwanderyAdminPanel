import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import 'package:sidebarx/sidebarx.dart';

import 'Login_Page.dart';
import 'colors.dart';
import 'widgets/custom_buuton.dart';

class ExampleSidebarX extends StatefulWidget {
  @override
  State<ExampleSidebarX> createState() => _ExampleSidebarXState();
}

class _ExampleSidebarXState extends State<ExampleSidebarX> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            CustomButton(
              color: Colors.transparent,
              width: 100,
              height: 40,
              text: 'No',
              textColor: Colors.red,
              onPressed: () {
                sidebarController.selectedindex.value = 0;

                Navigator.of(context).pop();
              },
            ),
            CustomButton(
              width: 100,
              height: 40,
              text: 'Yes',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  final SidebarController sidebarController = Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SidebarController>(
      builder: (sidebarController) {
        return SidebarX(
          controller: sidebarController.controller,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blueColor,
              borderRadius: BorderRadius.circular(20),
            ),
            hoverColor: Colors.transparent, // remove solid hover color
            textStyle: TextStyle(
              color: AppColors.backgroundColor,
              fontSize: 18,
            ),
            selectedTextStyle: TextStyle(
              color: AppColors.backgroundColor,
              fontSize: 18,
            ),
            hoverTextStyle: TextStyle(
              fontSize: 18,
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w600,
            ),
            itemTextPadding: const EdgeInsets.only(left: 10),
            selectedItemTextPadding: const EdgeInsets.only(left: 10),
            itemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.backgroundColor),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
              ),
              gradient: LinearGradient(
                colors: [AppColors.greenbutton, AppColors.backgroundColor], // Green gradient for selection
              ),
            ),
            iconTheme: IconThemeData(
              color: AppColors.backgroundColor,
              size: 10,
            ),
            selectedIconTheme: IconThemeData(
              color: AppColors.backgroundColor,
              size: 10,
            ),
          ),
          extendedTheme: SidebarXTheme(
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.blueColor,
            ),
          ),
          footerDivider: Divider(),
          headerBuilder: (context, extended) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Obx(
                      () => sidebarController.showsidebar.value == true
                      ? Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.clear_sharp,
                      color: Colors.yellowAccent,
                    ),
                  )
                      : SizedBox.shrink(),
                ),
                Get.width <= 1440
                    ? SizedBox(
                  height: 100,
                  width: 500,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/Drawer_logo.png')),
                )
                    : Get.width > 1440 && Get.width <= 2550
                    ? SizedBox(
                  height: 100,
                  width: 500,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/Drawer_logo.png')),
                )
                    : SizedBox(
                  height: 80,
                  width: 220,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/Drawer_logo.png')),
                ),
              ],
            );
          },
          items: [
            SidebarXItem(
              onTap: () {
                sidebarController.selectedindex.value = 0;
              },
              iconBuilder: (selected, hovered) {
                return Icon(
                  Icons.home,
                  color: Colors.transparent,
                );
              },
              label: 'User Data',
            ),
            SidebarXItem(
              onTap: () {
                sidebarController.selectedindex.value = 1;
              },
              iconBuilder: (selected, hovered) {
                return Icon(
                  Icons.home,
                  color: Colors.transparent,
                );
              },
              label: 'Add Events',
            ),
            SidebarXItem(
              onTap: () {
                sidebarController.selectedindex.value = 2;
              },
              iconBuilder: (selected, hovered) {
                return Icon(
                  Icons.home,
                  color: Colors.transparent,
                );
              },
              label: 'Edit Events',
            ),
            SidebarXItem(
              onTap: () {
                sidebarController.selectedindex.value = 3;
              },
              iconBuilder: (selected, hovered) {
                return Icon(
                  Icons.home,
                  color: Colors.transparent,
                );
              },
              label: 'Online Support',
            ),
            SidebarXItem(
              onTap: () {
                sidebarController.selectedindex.value = 0;
                sidebarController.controller = SidebarXController(selectedIndex: 0, extended: true);
                sidebarController.update();
                _showLogoutDialog();
              },
              iconBuilder: (selected, hovered) {
                return Icon(
                  Icons.home,
                  color: Colors.transparent,
                );
              },
              label: 'Log out',
            ),
          ],
        );
      },
    );
  }
}