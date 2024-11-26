import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import '../colors.dart';
import '../sidebar_controller.dart';
import '../widgets/custom_text.dart';

class UserDetails extends StatefulWidget {
  UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String searchQuery = '';
  final SidebarController sidebarController =Get.put(SidebarController());
  // Static user data for demonstration (replace with actual data later)


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.blueColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width < 380 ? 5 : width < 425
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
            SizedBox(
              height: width < 425
                  ? 20 // You can specify the width for widths less than 425
                  : width < 768
                  ? 20 // You can specify the width for widths less than 768
                  : width < 1024
                  ? 80 // You can specify the width for widths less than 1024
                  : width <= 1440
                  ? 80
                  : width > 1440 && width <= 2550
                  ? 80
                  : 80,
            ),
            Center(
              child: SizedBox(
                width: width < 425
                    ? 250 // You can specify the width for widths less than 425
                    : width < 768
                    ? 350 // You can specify the width for widths less than 768
                    : width < 1024
                    ? 400 // You can specify the width for widths less than 1024
                    : width <= 1440
                    ? 500
                    : width > 1440 && width <= 2550
                    ? 500
                    : 800,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery =
                          value.toLowerCase(); // Ensure case-insensitive search
                    });
                  },
                  decoration: InputDecoration(

                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: AppColors.blueColor,
                      fontSize: 16.0,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: secondaryColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width < 425
                      ? 20 // You can specify the width for widths less than 425
                      : width < 768
                      ? 20 // You can specify the width for widths less than 768
                      : width < 1024
                      ? 40 // You can specify the width for widths less than 1024
                      : width <= 1440
                      ? 100
                      : width > 1440 && width <= 2550
                      ? 100
                      : 80,
                  vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width < 425
                        ? 40
                        : width < 500
                        ? 40 // You can specify the width for widths less than 425
                        : width < 768
                        ? 40 // You can specify the width for widths less than 768
                        : width < 1024
                        ? 40 // You can specify the width for widths less than 1024
                        : width <= 1440
                        ? 50
                        : width > 1440 && width <= 2550
                        ? 50
                        : 80,
                  ),
                  Expanded(
                    child: AsulCustomText(
                      text: 'Name',
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: AsulCustomText(
                      // overflow: TextOverflow.ellipsis,
                      text: 'Email',
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: AsulCustomText(
                      text: 'Profile',
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: width < 425
                        ? 40
                        : width < 500
                        ? 40 // You can specify the width for widths less than 425
                        : width < 768
                        ? 90 // You can specify the width for widths less than 768
                        : width < 1024
                        ? 90 // You can specify the width for widths less than 1024
                        : width <= 1440
                        ? 80
                        : width > 1440 && width <= 2550
                        ? 80
                        : 80,
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding:  EdgeInsets.only(top: Get.height * .2),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.whiteColor),
                    ),
                  );
                } else if (snapshot.hasError) {
                  debugPrint("Error in user details home page: ${snapshot.error}");
                  return Center(
                    child: Text(
                      "An Error occurred",
                      style: jost500(16, AppColors.whiteColor),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "There are no users at the moment",
                      style: jost500(16, AppColors.whiteColor),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                    child: Text(
                      "No Internet!",
                      style: jost500(16, AppColors.whiteColor),
                    ),
                  );
                } else {
                  var users = snapshot.data!.docs;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width < 380
                                  ? 5
                                  : width < 425
                                  ? 15 // You can specify the width for widths less than 425
                                  : width < 768
                                  ? 20 // You can specify the width for widths less than 768
                                  : width < 1024
                                  ? 20 // You can specify the width for widths less than 1024
                                  : width <= 1440
                                  ? 90
                                  : width > 1440 && width <= 2550
                                  ? 90
                                  : 80),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // const SizedBox(width: 30),
                                  Container(
                                    width: width < 425
                                        ? 40 // You can specify the width for widths less than 425
                                        : width < 768
                                        ? 40 // You can specify the width for widths less than 768
                                        : width < 1024
                                        ? 50 // You can specify the width for widths less than 1024
                                        : width <= 1440
                                        ? 50
                                        : width > 1440 &&
                                        width <= 2550
                                        ? 50
                                        : 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: user['profile_pic'] != null
                                          ? Colors.transparent
                                          : Colors.red,
                                    ),
                                    child: user['profile_pic'] != null
                                        ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          user['profile_pic']),
                                    )
                                        : const Icon(Icons.person,
                                        color: Colors.white),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: width < 425
                                          ? 20 // You can specify the width for widths less than 425
                                          : width < 768
                                          ? 20 // You can specify the width for widths less than 768
                                          : width < 1024
                                          ? 50 // You can specify the width for widths less than 1024
                                          : width <= 1440
                                          ? 50
                                          : width > 1440 &&
                                          width <= 2550
                                          ? 50
                                          : 80,
                                      child: AsulCustomText(
                                        fontsize: width < 425
                                            ? 14 // You can specify the width for widths less than 425
                                            : width < 768
                                            ? 16 // You can specify the width for widths less than 768
                                            : width < 1024
                                            ? 15 // You can specify the width for widths less than 1024
                                            : width <= 1440
                                            ? 18
                                            : width > 1440 && width <= 2550
                                            ? 18
                                            : 30,

                                        overflow: TextOverflow.ellipsis,
                                        text: user['name']?.isNotEmpty == true
                                            ? user['name']
                                            : user['name'] ?? '',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                        width: width < 425
                                            ? 20 // You can specify the width for widths less than 425
                                            : width < 768
                                            ? 20 // You can specify the width for widths less than 768
                                            : width < 1024
                                            ? 50 // You can specify the width for widths less than 1024
                                            : width <= 1440
                                            ? 80
                                            : width > 1440 &&
                                            width <= 2550
                                            ? 80
                                            : 80,
                                        child: AsulCustomText(
                                          fontsize: width < 425
                                              ? 14 // You can specify the width for widths less than 425
                                              : width < 768
                                              ? 16 // You can specify the width for widths less than 768
                                              : width < 1024
                                              ? 15 // You can specify the width for widths less than 1024
                                              : width <= 1440
                                              ? 18
                                              : width > 1440 && width <= 2550
                                              ? 18
                                              : 30,
                                          overflow: TextOverflow.ellipsis,
                                          text: user['email'] ?? '',
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                  Expanded(
                                      child: AsulCustomText(
                                          fontsize: width < 425
                                              ? 14 // You can specify the width for widths less than 425
                                              : width < 768
                                              ? 16 // You can specify the width for widths less than 768
                                              : width < 1024
                                              ? 15 // You can specify the width for widths less than 1024
                                              : width <= 1440
                                              ? 18
                                              : width > 1440 && width <= 2550
                                              ? 18
                                              : 30,

                                          text: user["profile_type"],
                                          textAlign: TextAlign.center)),
                                  width < 500
                                      ? Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Handle edit action (replace with actual functionality)
                                        },
                                        iconSize: 25,
                                        icon: const Icon(Icons.edit),
                                        color: AppColors.backgroundColor,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Handle delete action (replace with actual functionality)
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        iconSize: 25,
                                      ),
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Handle edit action (replace with actual functionality)
                                        },
                                        icon: const Icon(Icons.edit),
                                        iconSize: 25,
                                        color: AppColors.backgroundColor,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Handle delete action (replace with actual functionality)
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                        iconSize: 25,
                                      ),
                                    ],
                                  ),

                                  // const SizedBox(width: 80),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }


              }
            ),
          ],
        ),
      ),
    );
  }
}