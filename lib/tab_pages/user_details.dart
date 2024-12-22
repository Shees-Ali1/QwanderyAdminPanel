import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/tab_pages/home_table_headings.dart';
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

  double calculatedWith(double width) {
    if (width <= 430 && width > 300) return width * 0.95;
    if (width <= 768 && width > 430) return width * 0.95;
    if (width <= 1024 && width > 768) return width * 0.6;
    if (width <= 1440 && width > 1024) return width * 0.7;
    if (width <= 2900 && width > 1440) return width * 0.9;
    return Get.width * 0.5;
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    final ScrollController _scrollController = ScrollController();

    final isWideScreen = width > 800;

    double innerFontSize = width <= 425
        ? 10
        : width <= 768 && width > 425
        ? 12
        : width <= 1024 && width >768
        ? 13
        : width <= 1440 && width > 1024
        ? 16
        : width > 1440 && width <= 2570
        ? 26
        : 5;

    return Container(
      height: Get.height,
      width: calculatedWith(width),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.blueColor, AppColors.greenbutton])
      ),
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding:  EdgeInsets.only(top: Get.height * .23),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").where("is_deleted", isEqualTo: false).snapshots(),
            builder: (context, snapshot) {


              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: Colors.white,);
              } else if (snapshot.hasError) {
                debugPrint("Error:  ${snapshot.error}");
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No users found'));
              }

              final users = snapshot.data!.docs;



              return RawScrollbar(
                thumbColor: Colors.white,
                thickness: 5,
                padding: EdgeInsets.only(bottom: 10),
                radius: Radius.circular(7),
                controller: _scrollController,
                interactive: true, // Enables mouse drag on web
                trackVisibility: true,
                thumbVisibility: true, // Ensures thumb is visible
                child: SingleChildScrollView(
                  controller: _scrollController,
                  // physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        horizontalMargin: 0,
                        columnSpacing: 10.0, // Adjust spacing for columns
                        dataTextStyle: TextStyle(
                          fontSize: 12, // Adjust font size for data
                          color: AppColors.whiteColor,
                        ),
                        columns: [
                          DataColumn(headingRowAlignment: MainAxisAlignment.start
                              ,label: ProfilePic(width: width)),
                          DataColumn(
                              headingRowAlignment: MainAxisAlignment.start,
                              label: NameContainer(width: width)),
                          DataColumn(
                              label: EmailContainer(width: width)),
                          DataColumn(
                              label: ChatBlock(width: width)),
                          DataColumn(
                              label: BlockContainer(width: width)),
                          DataColumn(
                              label: DeleteContainer(width: width)),
                        ],
                        rows: [],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            horizontalMargin: 0,
                            dataRowMaxHeight: 70,
                            dataRowMinHeight: 69,
                            columnSpacing: 10.0, // Adjust spacing for columns
                            headingTextStyle: jost700(
                                width > 1440 && width <= 2570
                                    ? 7
                                    : width < 430
                                    ? 13
                                    : width <= 1024
                                    ? 11
                                    : width <= 770
                                    ? 13
                                    : 9,
                                Colors.white),
                            dataTextStyle: TextStyle(
                              fontSize: 12, // Adjust font size for data
                              color: Colors.white,
                            ),
                            headingRowHeight: 0, // Hide column headers in rows
                            columns: [
                              DataColumn(
                                  label: SizedBox
                                      .shrink()), // Keep it blank since header is already fixed
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                            ],
                            rows: users.map((user) {
                              return DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: width <= 425
                                        ? 70
                                        : width <= 768 && width > 425
                                        ? 100
                                        : width <=1024 && width > 768
                                        ? 100
                                        : width <= 1440 && width > 1024
                                        ? 120
                                        : width > 1440 && width <= 2570
                                        ? 180 : 80,
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(user["profile_pic"]),
                                        backgroundColor: AppColors.secondaryColor,
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(

                                    width: width <= 425
                                        ? 100
                                        : width <= 768 && width > 425
                                        ? 110
                                        : width <=1024 && width > 768
                                        ? 130
                                        : width <= 1440 && width > 1024
                                        ? 180
                                        : width > 1440 && width <= 2570
                                        ? 240 : 350,
                                    child: Text(
                                      user["name"],
                                      style: jost700(innerFontSize, Colors.white),
                                    ),
                                  ),),
                                  DataCell(Container(
                                    width: width <= 425
                                        ? 190
                                        : width <= 768 && width > 425
                                        ? 220
                                        : width <=1024 && width > 768
                                        ? 240
                                        : width <= 1440 && width > 1024
                                        ? 300
                                        : width > 1440 && width <= 2570
                                        ? 440
                                        : 350,
                                    child: Text(user["email"],
                                      style: jost700(innerFontSize, Colors.white),),
                                  )),
                                  DataCell(Container(
                                    alignment: Alignment.center,
                                    width: width <= 425
                                        ? 110
                                        : width <=768 && width > 425
                                        ? 100
                                        : width <=1024 && width > 768
                                        ? 110
                                        : width <= 1440
                                        ? 154
                                        : width > 1440 && width <= 2570
                                        ? 240 : 150,
                                    child: Transform.scale(
                                      scale: width <= 425
                                          ? 0.7
                                          : width <= 768
                                          ? 0.7
                                          : width <= 1024
                                          ? 0.7
                                          : width <= 1440
                                          ? 0.8
                                          : width > 1440 && width <= 2570
                                          ? 1
                                          : 1,
                                      // isWideScreen?1:0.5, // Adjust the scale factor to increase/decrease size
                                      child: Switch(
                                        activeTrackColor: AppColors.blueColor,
                                        inactiveTrackColor: AppColors.secondaryColor,
                                        inactiveThumbColor: AppColors.blueColor,
                                        activeColor: AppColors.secondaryColor,
                                        focusColor: AppColors.blueColor,
                                        value: user["chat_blocked"],
                                        onChanged: (value) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user["uid"])
                                              .update({'chat_blocked': value}).then(
                                                  (_) {

                                                // if(value == true){
                                                //   notificationVM.notifyUser(context: context, title: "Chat Blocked", message: "The Admin has blocked you from chatting with any personnel", userId: user.uid, type: "Admin notification");
                                                // } else {
                                                //   notificationVM.notifyUser(context: context, title: "Chat Restrictions Removed", message: "The Admin has removed restrictions on your Chats", userId: user.uid, type: "Admin notification");
                                                // }


                                                debugPrint('User ${user["uid"]} chat block status updated to $value');
                                              }).catchError((error) {
                                            debugPrint(
                                                'Failed to update user: $error');
                                          });
                                        },
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(
                                    alignment: Alignment.center,
                                    width: width <= 425
                                        ? 70
                                        : width <=768 && width > 425
                                        ? 80
                                        : width <=1024 && width > 768
                                        ? 80
                                        : width <= 1440 && width > 1024
                                        ? 154
                                        : width > 1440 && width <= 2570
                                        ? 210 : 150,
                                    child: Transform.scale(
                                      // alignment: Alignment.center,
                                      scale: width <= 425
                                          ? 0.7
                                          : width <= 768
                                          ? 0.7
                                          : width <= 1024
                                          ? 0.7
                                          : width <= 1440
                                          ? 0.8
                                          : width > 1440 && width <= 2570
                                          ? 1
                                          : 1,
                                      // isWideScreen?1:0.5, // Adjust the scale factor to increase/decrease size
                                      child: Switch(
                                        activeTrackColor: AppColors.blueColor,
                                        inactiveTrackColor: AppColors.secondaryColor,
                                        inactiveThumbColor: AppColors.blueColor,
                                        activeColor: AppColors.secondaryColor,
                                        focusColor: AppColors.blueColor,
                                        value: user["is_blocked"],
                                        onChanged: (value) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user["uid"])
                                              .update({'is_blocked': value}).then(
                                                  (_) {


                                                debugPrint('User ${user["uid"]} block status updated to $value');
                                              }).catchError((error) {
                                            debugPrint(
                                                'Failed to update user: $error');
                                          });
                                        },
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(
                                    alignment: Alignment.center,
                                    width: width <= 425
                                        ? 70
                                        : width <=768 && width > 425
                                        ? 80
                                        : width <=1024 && width > 768
                                        ? 80
                                        : width <= 1440 && width > 1024
                                        ? 154
                                        : width > 1440 && width <= 2570
                                        ? 210 : 150,
                                    child: Transform.scale(
                                      // alignment: Alignment.center,
                                      scale: width <= 425
                                          ? 0.7
                                          : width <= 768
                                          ? 0.7
                                          : width <= 1024
                                          ? 0.7
                                          : width <= 1440
                                          ? 0.8
                                          : width > 1440 && width <= 2570
                                          ? 1
                                          : 1,
                                      // isWideScreen?1:0.5, // Adjust the scale factor to increase/decrease size
                                      child: GestureDetector(
                                          onTap: (){
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user["uid"])
                                                .update({
                                                'is_deleted': true,
                                                "profile_pic": "",
                                                'name': "Deleted User",
                                                "bio": "",
                                                "followers": [],
                                                "following": [],
                                                "events": [],
                                                "favourites": [],
                                                "requested": [],
                                                "email": "",
                                                "location": "",

                                                }).then(
                                                    (_) {

                                                  // if(value == true){
                                                  //   notificationVM.notifyUser(context: context, title: "Chat Blocked", message: "The Admin has blocked you from chatting with any personnel", userId: user.uid, type: "Admin notification");
                                                  // } else {
                                                  //   notificationVM.notifyUser(context: context, title: "Chat Restrictions Removed", message: "The Admin has removed restrictions on your Chats", userId: user.uid, type: "Admin notification");
                                                  // }


                                                  debugPrint('User ${user["uid"]} delete status updated to true');
                                                }).catchError((error) {
                                              debugPrint(
                                                  'Failed to update user: $error');
                                            });
                                          },
                                          child: Icon(Icons.delete, size: 30, color: Colors.red,))
                                    ),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}