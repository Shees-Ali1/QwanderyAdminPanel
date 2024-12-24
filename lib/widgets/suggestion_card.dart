import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/controllers/suggestion_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';

class SuggestionCard extends StatefulWidget {
  const SuggestionCard({super.key, required this.imageAsset, required this.title, required this.date, required this.location, required this.credits, required this.priceRange,  this.event});

  final String imageAsset; // Change this to imageAsset
  final String title;
  final String date;
  final String location;
  final String credits;
  final String priceRange;
  final QueryDocumentSnapshot<Object?>? event;

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  final SuggestionController suggestVM = Get.put(SuggestionController());
  final SidebarController sidebarController = Get.put(SidebarController());


  Future<int> _fetchSuggestionsCount() async {
    try {
      // Get the event document
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event!["event_id"])
          .get();

      // Check if the event document exists
      if (eventDoc.exists) {
        // Get the suggestions subcollection
        CollectionReference suggestionsRef = eventDoc.reference.collection('suggestions');

        // Get the count of documents in the subcollection
        QuerySnapshot suggestionsSnapshot = await suggestionsRef.get();
        return suggestionsSnapshot.docs.length; // Return the count
      } else {
        return 0; // If event document doesn't exist
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return 0; // Return 0 in case of an error
    }
  }

  int _getTotalCredits(List ceCreditsList) {
    int credits = 0;

    // Loop through the list and sum up all the credits_earned
    for (var item in ceCreditsList) {
      credits += (item['credits_earned'] as num?)?.toInt() ?? 0;
    }

    // Update the state with the total credits
    return credits;
  }


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
                        (widget.date.isNotEmpty && widget.event!["single_date"] == true) ? widget.date : widget.event!["multiple_event_dates"][0],
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
                        _getTotalCredits(widget.event!["credits_and_topics"]).toString() + "CE Creds.",
                        style: jost600(fontSize, AppColors.backgroundColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<int>(
                    future: _fetchSuggestionsCount(), // Call the fetch function
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            Icon(Icons.settings_suggest_outlined, size: 14.0, color: AppColors.backgroundColor),
                            SizedBox(width: 10), // Space between price range and suggestion count
                            Text(
                              "...", // Show suggestions count
                              style: jost600(14.0, AppColors.backgroundColor),
                            ),
                          ],
                        ); // Show loading while waiting
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}"); // Show error if any
                      } else if (snapshot.hasData) {
                        int suggestionsCount = snapshot.data ?? 0;

                        return Row(
                          children: [
                            Icon(Icons.settings_suggest_outlined, size: 14.0, color: AppColors.backgroundColor),
                            SizedBox(width: 10), // Space between price range and suggestion count
                            Text(
                              suggestionsCount.toString(), // Show suggestions count
                              style: jost600(14.0, AppColors.backgroundColor),
                            ),
                          ],
                        );
                      } else {
                        return Text("No suggestions"); // Default message if no data
                      }
                    },
                  ),
                  SizedBox(height: 10),

                  /// View Button
                  SizedBox(
                    width: 100,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {
                        // suggestVM.nameController.text = widget.suggestions["eventName"];
                        // suggestVM.correctionsController.text = widget.suggestions["corrections"];
                        // suggestVM.complaintController.text = widget.suggestions["complaints"];
                        // suggestVM.sugguestNewController.text = widget.suggestions["suggestNew"].toString();
                        // suggestVM.suggestionController.text = widget.suggestions["suggestions"].toString();


                        suggestVM.suggestion_id.value = widget.event!["event_id"];

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
