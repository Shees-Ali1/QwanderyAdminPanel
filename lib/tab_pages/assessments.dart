
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';

import '../colors.dart';



class Assessments extends StatefulWidget {
  const Assessments({super.key});

  @override
  State<Assessments> createState() => _AssessmentsState();
}

class _AssessmentsState extends State<Assessments> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final SidebarController sidebarController =Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: AppColors.blueColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width<380?5:width < 425
              ? 15 // You can specify the width for widths less than 425
              : width < 768
              ? 20 // You can specify the width for widths less than 768
              : width < 1024
              ? 70 // You can specify the width for widths less than 1024
              : width <= 1440
              ? 60
              : width > 1440 && width <= 2550
              ? 60
              : 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            Get.width<768?  GestureDetector(
              onTap: () {
                sidebarController.showsidebar.value =true;
              },
              child:SvgPicture.asset('assets/drawernavigation.svg',color: AppColors.backgroundColor,),

            )
                :SizedBox.shrink(),
            const SizedBox(height: 25),

          ],
        ),
      ),
    );
  }
}

