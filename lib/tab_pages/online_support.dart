import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/images.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/controllers/chat_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import 'package:iw_admin_panel/widgets/online_support_widget.dart';

class OnlineSupport extends StatefulWidget {
  const OnlineSupport({super.key});

  @override
  State<OnlineSupport> createState() => _OnlineSupportState();
}

class _OnlineSupportState extends State<OnlineSupport> {
  final SidebarController sidebarController = Get.put(SidebarController());


  final ChatController chatVM = Get.put(ChatController());
  final TextEditingController message = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  String timeAgo(DateTime time) {
    final dateTime = DateTime.parse(time.toString());
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return "1 day ago";
      } else {
        return "${difference.inDays} days ago";
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return "1 hour ago";
      } else {
        return "${difference.inHours} hours ago";
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return "1 minute ago";
      } else {
        return "${difference.inMinutes} minutes ago";
      }
    } else if (difference.inSeconds > 0) {
      return "Just now";
    } else {
      return "Just now"; // In case the DateTime is in the future (e.g., invalid)
    }
  }

  double userWidgetWidth(double width) {
    if (width <= 430) return width * 0.25;
    if (width <= 768) return width * 0.25;
    return Get.width * 0.2;
  }

  @override
  void dispose(){
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {


    final width = MediaQuery
        .of(context)
        .size
        .width;

    double headingFont = width <= 425 && width > 375
        ? 14
        : width <= 768 && width > 425
        ? 18
        : width <= 1024 && width > 768
        ? 18
        : width <= 1440 && width > 1024
        ? 20
        : width > 1440 && width <= 2570
        ? 26
        : 12;


    return Scaffold(
        backgroundColor: AppColors.blueColor,
        body: Padding(
          padding: EdgeInsets.only(top: width < 600 ? 10 : 100, left: 5),
          child: Obx(
                () =>
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if(Get.width > 600)
                      SingleChildScrollView(
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
                                      width: userWidgetWidth(width),
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15),
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
                                                      chatVM.user_id.value =
                                                      user['uid'];
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
                      ),
                    if(Get.width > 600)
                      SizedBox(width: 20,),
                    onlineSupportChat(),
                  ],
                ),
          ),
        )
    );
  }

  Widget onlineSupportChat(){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double chatContainerWidth(double width) {
      if (width <= 430) return width * 0.95;
      if (width <= 600) return width * 0.9;
      if (width <= 768) return width * 0.6;
      if (width <= 1024) return width * 0.52;
      if (width <= 1440) return width * 0.54;
      if (width <= 2056) return width * 0.56;
      return Get.width * 0.5;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 6,
        bottom: 30,
      ),
      child: Container(
        width: chatContainerWidth(width),
        decoration: BoxDecoration(
          color: AppColors.blueColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.lighterBlueColor,
              blurRadius: 6.0,
              offset: Offset(1, 4),
            ),
          ],
        ),
        child: Column(
            children: [
              if(chatVM.user_id.value != "")
              Expanded(
                child:StreamBuilder(
                      stream: chatVM.getMessages(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(color: AppColors.blueColor,));
                        } else if (snapshot.hasError){
                          debugPrint("Error in fetching support messages: ${snapshot.error}");
                          return Center(child: Text("An Error occurred", style: jost500(16, AppColors.blueColor),));
                        } else if(snapshot.data!.docs.length == 0 && snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("There are no messages.", style: jost500(16, AppColors.blueColor),));
                        } else if(snapshot.connectionState == ConnectionState.none){
                          return  Center(child: Text("No Internet!", style: jost500(16, AppColors.blueColor),));
                        } else if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){

                          var messages = snapshot.data!.docs;

                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return messages[index]["user_uid"] != FirebaseAuth.instance.currentUser!.uid
                                  ? _buildSupportMessage(messages[index]["message"], messages[index]["sent_at"].toDate())
                                  : _buildUserMessage(messages[index]["message"], messages[index]["sent_at"].toDate());
                            },
                          );
                        } else {
                          return SizedBox();
                        }

                      }
                  )
              ),
              if(chatVM.user_id.value == "")
                Expanded(child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Center(
                      child: Text("Open a Chat.", style: jost500(20, Colors.white),),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                )),
              if(chatVM.user_id.value != "")
                _buildMessageInput(),
            ],
          )
      ),
    );
  }

  /// Support Team Text Field Design
  Widget _buildSupportMessage(String message, DateTime time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile Image
        // Container(
        //   height: 37.92.h,
        //   width: 37.92,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //   ),
        //
        //     child: Image.asset(AppImages.profile_image_small,fit: BoxFit.contain,),
        // ),
        // CircleAvatar(
        //   radius: 18.46,
        //   backgroundColor: AppColors.blueColor,
        //   child: Icon(Icons.person, size: 20, color: AppColors.greenbutton,),
        // ),
        SizedBox(width: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,

          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 28, 49, 1), // Support bubble color
                  borderRadius: BorderRadius.circular(5.69),
                ),
                child: Text(
                  message,
                  style:  jost500(12, AppColors.appbar_text),
                ),
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding:  EdgeInsets.only(bottom: 8.0),
              child: Text(timeAgo(time), style: jost500(10, AppColors.whiteColor),),
            )
          ],
        ),
      ],
    );
  }

  /// User Text Message Field Design
  Widget _buildUserMessage(String message, DateTime time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:  EdgeInsets.only(bottom: 5.0),
              child: Text(timeAgo(time), style: jost500(10, AppColors.whiteColor),),
            ),
            SizedBox(width: 8),

            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 220, // Limit the message bubble width to 220
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.fillcolor, // User bubble color
                  borderRadius: BorderRadius.circular(5.69),
                ),
                child: Text(
                  message,
                  style: jost500(12, AppColors.calendartext),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Type Message TextField
  Widget _buildMessageInput() {
    final width = MediaQuery.of(context).size.width;



    return Container(
      height: 79.8,
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff001A2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:width <= 768 ? 16 : 23.4),
        child: SizedBox(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: width <= 768 ? 30 : 56.63, // Height for the container
                  width: double.infinity, // Set to your desired width
                  child: TextField(
                    controller: message,
                    onEditingComplete: (){
                      chatVM.sendMessage(message.text.trim(), DateTime.now(), message);
                    },

                    decoration: InputDecoration(

                      hintText: 'Type message...',
                      hintStyle: jost500( width <= 768 ? 14 : 17, AppColors.calendartext),
                      filled: true,
                      fillColor: AppColors.fillcolor,
                      contentPadding: EdgeInsets.symmetric(horizontal: width <= 768 ? 10 : 15, vertical: width <= 768 ? 12 : 18), // Adjust vertical padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width <= 768 ? 7 :15),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true, // Set isDense to true
                    ),
                    style: jost500( width <= 768 ? 14 : 17, AppColors.calendartext),
                  ),
                ),
              ),
              SizedBox(width:width <= 768 ? 8 : 11.52),
              InkWell(
                autofocus: false,
                onTap: (){
                  chatVM.sendMessage(message.text.trim(), DateTime.now(), message);
                },
                child: Container(
                  height:width <= 768 ? 30 : 38.4,
                  width:width <= 768 ? 30 : 38.4,
                  decoration: BoxDecoration(
                      color: AppColors.fillcolor, // Send button color
                      borderRadius: BorderRadius.circular(11.52)
                  ),
                  child: Center(
                    child: SizedBox(
                      height: width <= 768 ? 18 :  23.04,
                      width: width <= 768 ? 18 : 23.04,
                      child: Image.asset(AppImages.send_image_icon,
                        color: AppColors.blueColor,
                        fit: BoxFit.contain,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

}
