import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/controllers/suggestion_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import 'package:iw_admin_panel/widgets/suggestion_card.dart';

import '../const/textstyle.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({super.key});

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  final SuggestionController suggestionVM = Get.put(SuggestionController());
  final SidebarController sidebarController = Get.put(SidebarController());


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double headingFont = width <= 425 && width > 375
        ? 14
        : width <= 768 && width > 425
        ? 18
        : width <= 1024 && width >768
        ? 18
        : width <= 1440 && width > 1024
        ? 20
        : width > 1440 && width <= 2570
        ? 26
        : 12;

    double spacing(double width){
      if (width <= 430 && width > 300) return 10;
      if (width <= 768 && width > 430) return 12;
      if (width <= 1024 && width > 768) return 14;
      if (width <= 1440 && width > 1024) return 15;
      if (width <= 2900 && width > 1440) return 20;
      return 15;
    }

    double containerWidth(double width){
      if (width <= 430 && width > 300) return width * .95;
      if (width <= 500 && width > 430) return width * .8;
      if (width <= 768 && width > 500) return width * .7;
      if (width <= 1024 && width > 768) return width * .52;
      if (width <= 1440 && width > 1024) return width * .5;
      if (width <= 1800 && width > 1440) return width * .4;
      if (width <= 2900 && width > 1800) return width * .3;
      return width * .5;
    }


    sidebarController.selectedDrawer.value = "Simple";


    return Container(
      height: Get.height,
      color: AppColors.blueColor,
      child: Obx((){
        return suggestionVM.suggestion_id.value != "" && suggestionVM.view.value == false
            ? allSuggestions(context)
            :  suggestionVM.suggestion_id.value != "" && suggestionVM.view.value == true
            ? suggestionsView(context)
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: height < 768 ? 10 : 40,
            ),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding:  EdgeInsets.only(top: Get.height * .5),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.whiteColor),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      debugPrint("Error in events future home page: ${snapshot.error}");
                      return Center(
                        child: Text(
                          "An Error occurred",
                          style: jost500(16, AppColors.whiteColor),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "There are no events at the moment",
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

                      var events = snapshot.data!.docs;

                      return MasonryGridView.builder(
                        physics:  NeverScrollableScrollPhysics(),
                        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: width < 768 ? 1 : 2),
                        shrinkWrap: true,
                        padding: width <= 768 ? EdgeInsets.symmetric(horizontal: width < 375 ? 10 : 15) : EdgeInsets.zero,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SuggestionCard(
                              event: events[index],
                              imageAsset: events[index]['event_image'],
                              title: events[index]['event_name'],
                              date: events[index]['event_date'],
                              location: events[index]['event_location'],
                              credits: '10 CE Credits',
                              priceRange: "\$" + events[index]['event_price'].toString() + "/seat",
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget allSuggestions(BuildContext context){
    final SuggestionController suggestVM = Get.put(SuggestionController());

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    double fontSize = width <= 425 && width > 375
        ? 10
        : width <= 768 && width > 425
        ? 12
        : width < 375 ? 9 : 15;

    return Container(
      height: Get.height,
      color: AppColors.blueColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height < 768 ? 10 : 40,
          ),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('events').doc(suggestionVM.suggestion_id.value).collection("suggestions").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding:  EdgeInsets.only(top: Get.height * .5),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.whiteColor),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    debugPrint("Error in events future home page: ${snapshot.error}");
                    return Center(
                      child: Text(
                        "An Error occurred",
                        style: jost500(16, AppColors.whiteColor),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "There are no events at the moment",
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

                    var events = snapshot.data!.docs;

                    return MasonryGridView.builder(
                      physics:  NeverScrollableScrollPhysics(),
                      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: width < 768 ? 1 : 3),
                      shrinkWrap: true,
                      padding: width <= 768 ? EdgeInsets.symmetric(horizontal: width < 375 ? 10 : 15) : EdgeInsets.zero,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: AppColors.blueColor,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondaryColor,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0), // Increased overall padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Suggest Event Name: ${events[index]['eventName']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: jost700(fontSize, AppColors.backgroundColor),
                                  ),
                                  SizedBox(height: 8),

                                  Text(
                                    "Corrections: ${events[index]['corrections']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: jost600(fontSize, AppColors.backgroundColor),
                                  ),
                                  SizedBox(height: 8),

                                  Text(
                                    "Suggest New: ${events[index]['suggestNew']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: jost600(fontSize, AppColors.backgroundColor),
                                  ),
                                  SizedBox(height: 8),

                                  Text(
                                    "Complaints: ${events[index]['complaints']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: jost600(fontSize, AppColors.backgroundColor),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Suggestions: ${events[index]['suggestions']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: jost600(fontSize, AppColors.backgroundColor),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child:  SizedBox(
                                      width: 100,
                                      height: 28,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          suggestVM.nameController.text = events[index]["eventName"];
                                          suggestVM.correctionsController.text = events[index]["corrections"];
                                          suggestVM.complaintController.text = events[index]["complaints"];
                                          suggestVM.sugguestNewController.text = events[index]["suggestNew"].toString();
                                          suggestVM.suggestionController.text = events[index]["suggestions"].toString();


                                          suggestVM.view.value = true;

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.fillcolor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            fontFamily: "Jost",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget suggestionsView(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double headingFont = width <= 425 && width > 375
        ? 14
        : width <= 768 && width > 425
        ? 18
        : width <= 1024 && width >768
        ? 18
        : width <= 1440 && width > 1024
        ? 20
        : width > 1440 && width <= 2570
        ? 26
        : 12;

    double spacing(double width){
      if (width <= 430 && width > 300) return 10;
      if (width <= 768 && width > 430) return 12;
      if (width <= 1024 && width > 768) return 14;
      if (width <= 1440 && width > 1024) return 15;
      if (width <= 2900 && width > 1440) return 20;
      return 15;
    }

    double containerWidth(double width){
      if (width <= 430 && width > 300) return width * .95;
      if (width <= 500 && width > 430) return width * .8;
      if (width <= 768 && width > 500) return width * .7;
      if (width <= 1024 && width > 768) return width * .52;
      if (width <= 1440 && width > 1024) return width * .5;
      if (width <= 1800 && width > 1440) return width * .4;
      if (width <= 2900 && width > 1800) return width * .3;
      return width * .5;
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.blueColor, AppColors.greenbutton])
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: height < 768 ? 10 : 40,
          ),
          child: Container(
            width: containerWidth(width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Suggestions",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: headingFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: spacing(width)),
                Text('Suggested Event Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Suggested Event Name", context, suggestionVM.nameController, maxLines: 1),
                Text('Corrections',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Corrections", context, suggestionVM.correctionsController, maxLines: 3),
                SizedBox(height: spacing(width)),
                Text('New Suggested Event',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("New Suggested Event", context, suggestionVM.sugguestNewController, maxLines: 3),
                SizedBox(height: spacing(width)),
                Text('Complaints',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Complaints", context, suggestionVM.complaintController, maxLines: 3),
                SizedBox(height: spacing(width)),
                Text('Enter Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Event Description", context, suggestionVM.suggestionController, maxLines: 5),
                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String labelText,
      BuildContext context,
      TextEditingController controller, {
        bool isNumber = false,
        int maxLines = 1,
      }) {

    final width = MediaQuery.of(context).size.width;

    double verticalPadding(double width){
      if (width <= 430 && width > 300) return 10;
      if (width <= 768 && width > 430) return 10;
      if (width <= 1024 && width > 768) return 14;
      if (width <= 1440 && width > 1024) return 16;
      if (width <= 2900 && width > 1440) return 16;
      return Get.width * 0.5;
    }

    double horizontalPadding(double width){
      if (width <= 430 && width > 300) return 14;
      if (width <= 768 && width > 430) return 10;
      if (width <= 1024 && width > 768) return 16;
      if (width <= 1440 && width > 1024) return 20;
      if (width <= 2900 && width > 1440) return 20;
      return Get.width * 0.5;
    }

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: jost400(17, Colors.black),
      decoration: InputDecoration(
        labelText: null, // Removes the label text
        hintText: null,
        isDense: true,// Ensures there's no hint text inside the field
        contentPadding: EdgeInsets.symmetric(vertical: verticalPadding(width), horizontal: horizontalPadding(width)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey[300]!), // Lighter border color
        ),
        filled: true,
        fillColor: Color.fromRGBO(240, 240, 240, 1), // Lighter background color
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.blueColor), // Focused border color
        ),
      ),
    );
  }
}
