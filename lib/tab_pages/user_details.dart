import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
  final List<Map<String, dynamic>> users = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'Admin',
      'profileImageUrl': 'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200&d=mp&r=g', // Replace with actual image URL
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'role': 'User',
      'profileImageUrl': 'https://www.gravatar.com/avatar/02484d0c383c8804c4827c85b2246e17?s=200&d=mp&r=g', // Replace with actual image URL
    },
    // Add more users here...
  ];

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
                      text: 'Role',
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
            Expanded(
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
                                color: user['profileImageUrl'] != null
                                    ? Colors.transparent
                                    : Colors.red,
                              ),
                              child: user['profileImageUrl'] != null
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    user['profileImageUrl']),
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

                                    text: user['role'] ?? '',
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
                                  color: primaryColorKom,
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
                                  color: primaryColorKom,
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
            ),
          ],
        ),
      ),
    );
  }
}