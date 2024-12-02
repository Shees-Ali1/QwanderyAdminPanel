import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/controllers/chat_controller.dart';
import 'package:iw_admin_panel/widgets/online_support_widget.dart';

import '../const/textstyle.dart';

class OnlineSupportDrawer extends StatefulWidget {
  const OnlineSupportDrawer({super.key});

  @override
  State<OnlineSupportDrawer> createState() => _OnlineSupportDrawerState();
}

class _OnlineSupportDrawerState extends State<OnlineSupportDrawer> {
  final ChatController chatVM = Get.put(ChatController());


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .4,
      height: Get.height,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [

        ],
      ),
    );
  }

  Widget allChats(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("online_support").snapshots(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(top: Get.height * .4),
                  child: SizedBox(
                    width: Get.width * .2,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.whiteColor),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint("Error in events stream home page: ${snapshot.error}");
                return Center(
                  child: Text(
                    "An Error occurred",
                    style: jost500(16, AppColors.blueColor),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "There are no chat at the moment",
                    style: jost500(16, AppColors.blueColor),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
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
                    width: Get.width * .2,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      itemCount: onlineSupporters.length,
                      itemBuilder: (context, index) {
                        // Extract the user UID
                        var uid = onlineSupporters[index]['uid'];

                        // Fetch the user data based on the UID using FutureBuilder
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox();
                            } else if (userSnapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Center(
                                  child: Text("Error loading user data", style: jost500(16, AppColors.blueColor)),
                                ),
                              );
                            } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Center(
                                  child: Text("User not found", style: jost500(16, AppColors.blueColor)),
                                ),
                              );
                            } else {
                              // Access user data
                              var user = userSnapshot.data!;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  autofocus: false,
                                  onTap: (){
                                    chatVM.user_id.value = user['uid'];
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
