import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/images.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/controllers/event_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';

class EventCard extends StatefulWidget {
  final String imageAsset; // Change this to imageAsset
  final String title;
  final String date;
  final String location;
  final String credits;
  final String priceRange;
  final QueryDocumentSnapshot<Object?>? event;

  const EventCard({
    Key? key,
    required this.imageAsset, // Update constructor parameter
    required this.title,
    required this.date,
    required this.location,
    required this.credits,
    required this.priceRange,
    required this.event,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final EventController eventVM = Get.put(EventController());
  final SidebarController sidebarController = Get.put(SidebarController());


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;


    double fontSize = width <= 425 && width > 375
        ? 10
        : width <= 768 && width > 425
        ? 12
        : width < 375 ? 9 : 10;

    return Container(
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
        child: Row(
          children: [
            /// Main Image on the Left
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Slightly larger radius
              child: Container(
                height: double.infinity, // Use responsive height
                width: width < 330 ? 130 : 150, // Adjusted width for image
                decoration: BoxDecoration(
                    color: AppColors.lighterBlueColor
                ),
                child: Image.network(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12), // Increased spacing between image and text

            /// Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Title and Bookmark Icon
                  Text(
                    widget.title,
                    style: jost700(fontSize, AppColors.backgroundColor), // Slightly larger font
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8), // Added spacing between title and other elements

                  /// Date and Location Row
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.calendar, size: 14.0, color: AppColors.backgroundColor),
                      SizedBox(width: 6),
                      Text(
                        widget.date,
                        style: jost600(fontSize, AppColors.backgroundColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14.0, color: AppColors.backgroundColor),
                      SizedBox(width: 6),
                      Text(
                        widget.location,
                        style: jost600(fontSize, AppColors.backgroundColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.bookOpen,
                        size: 12.0,
                        color: AppColors.backgroundColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        widget.credits,
                        style: jost600(fontSize, AppColors.backgroundColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.tag, size: 14.0, color: AppColors.backgroundColor),
                      SizedBox(width: 6),
                      Text(
                        widget.priceRange,
                        style: jost600(fontSize, AppColors.backgroundColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// View Button
                  SizedBox(
                    width: 100,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {
                        eventVM.eventImageController.text = widget.event!["event_image"];
                        eventVM.eventNameController.text = widget.event!["event_name"];
                        eventVM.eventDateController.text = widget.event!["event_date"];
                        eventVM.eventPriceController.text = widget.event!["event_price"].toString();
                        eventVM.eventLocationController.text = widget.event!["event_location"];
                        eventVM.eventAddressController.text = widget.event!["event_building"];
                        eventVM.eventDescriptionController.text = widget.event!["event_description"];
                        eventVM.eventCreditsController.text = widget.event!["event_credits"];
                        eventVM.eventOrganizerController..text = widget.event!["event_organizer"];
                        eventVM.event_id.value = widget.event!["event_id"];

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fillcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: "Jost",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
