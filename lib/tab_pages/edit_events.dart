import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/images.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/controllers/event_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import 'package:iw_admin_panel/widgets/event_card.dart';
import 'package:iw_admin_panel/widgets/text_widget.dart';

class EditEvents extends StatefulWidget {
  const EditEvents({super.key});

  @override
  State<EditEvents> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvents> {
  final SidebarController sidebarController = Get.put(SidebarController());

  final EventController eventVM = Get.put(EventController());

  Uint8List? _image; // Variable to store the selected image

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  // Add event to Firestore
  Future<void> changeEvent(String event_id) async {
    if (eventVM.eventNameController.text.isEmpty ||
        eventVM.eventImageController.text.isEmpty ||
        eventVM.eventDateController.text.isEmpty ||
        eventVM.eventPriceController.text.isEmpty ||
        eventVM.eventLocationController.text.isEmpty ||
        eventVM.eventAddressController.text.isEmpty ||
        eventVM.eventDescriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {

      await _firestore.collection('events').doc(event_id).set({
        'event_image': eventVM.eventImageController.text.trim(),
        'event_name': eventVM.eventNameController.text.trim(),
        'event_date': eventVM.eventDateController.text.trim(),
        'event_price': eventVM.eventPriceController.text.trim(),
        'event_credits': eventVM.eventCreditsController.text.trim(),
        'event_location': eventVM.eventLocationController.text.trim(),
        'event_building': eventVM.eventAddressController.text.trim(),
        'event_description': eventVM.eventDescriptionController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
        'planned': [],
        'following': [],
        'favourited': [],
        'attending': [],
        'attended': [],
        'reviews': [],
        'event_organizer': eventVM.eventOrganizerController.text.trim(),
      }, SetOptions(merge: true));


      Get.snackbar(
        "Success",
        "Event edited successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear all fields
      eventVM.eventImageController.clear();
      eventVM.eventNameController.clear();
      eventVM.eventDateController.clear();
      eventVM.eventPriceController.clear();
      eventVM.eventLocationController.clear();
      eventVM.eventAddressController.clear();
      eventVM.eventDescriptionController.clear();
      eventVM.eventCreditsController.clear();
      eventVM.eventOrganizerController.clear();
      eventVM.city.value = "";
      eventVM.state.value = "";
      eventVM.country.value = "";
      eventVM.event_id.value = "";
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to edit event: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void Start_function(){
    if (eventVM.eventImageController.text.isEmpty) {
      Get.snackbar(
        "Event Image is empty!",
        "Please upload an event image.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventNameController.text.isEmpty) {
      Get.snackbar(
        "Event Name is empty!",
        "Please fill in the event name.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventDateController.text.isEmpty) {
      Get.snackbar(
        "Event Date is empty!",
        "Please choose the event date.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventPriceController.text.isEmpty) {
      Get.snackbar(
        "Event Price is empty!",
        "Please fill in the event price.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventLocationController.text.isEmpty) {
      Get.snackbar(
        "Event Location is empty!",
        "Please provide the event location.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventAddressController.text.isEmpty) {
      Get.snackbar(
        "Event Address is empty!",
        "Please fill in the event address.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventDescriptionController.text.isEmpty) {
      Get.snackbar(
        "Event Description is empty!",
        "Please provide a description for the event.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventCreditsController.text.isEmpty) {
      Get.snackbar(
        "Event Credits are empty!",
        "Please enter the credits for the event.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.eventOrganizerController.text.isEmpty) {
      Get.snackbar(
        "Event Organizer is empty!",
        "Please provide the event organizer's name.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    } else if (eventVM.city.value == "" && eventVM.country.value == "") {
      Get.snackbar(
        "City, Location not selected!",
        "Please select the event City, Country.",
        colorText: Colors.white,
        backgroundColor: AppColors.blueColor,
      );
    }  else {
     changeEvent(eventVM.event_id.value);
    }

  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.blueColor,
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: AppColors.greenbutton,
              onPrimary: AppColors.blueColor,
              secondary: AppColors.greenbutton,
              onSecondary: AppColors.greenbutton,
              error: Colors.red,
              onError: Colors.red,
              surface: AppColors.blueColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      // Format the selected date to your desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      eventVM.eventDateController.text = formattedDate; // Display the formatted date in the controller
    }
  }

  void _openLocationPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CSCPicker(
                  layout: Layout.vertical,
                  flagState: CountryFlag.DISABLE,
                  showStates: true, // Enable state picker
                  showCities: true, // Enable city picker
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                    border: Border.all(color: AppColors.blueColor),
                  ),
                  disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                    border: Border.all(color: AppColors.blueColor),
                  ),
                  searchBarRadius: 16,
                  onCountryChanged: (value) {
                    eventVM.country.value = value;
                    eventVM.state.value = "Select State"; // Reset state when country changes
                    eventVM.city.value = "Select City"; // Reset city when country changes
                  },
                  onStateChanged: (value) {
                    eventVM.state.value = value ?? "Select State";
                    eventVM.city.value = "Select City"; // Reset city when state changes
                  },
                  onCityChanged: (value) {
                    eventVM.city.value = value ?? "Select City";
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to pick an image from file picker
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes; // Retrieve the image bytes
      });
    }
  }

  // Method to show a dialog for choosing image source

  @override
  void dispose(){
    super.dispose();
    eventVM.eventImageController.clear();
    eventVM.eventNameController.clear();
    eventVM.eventDateController.clear();
    eventVM.eventPriceController.clear();
    eventVM.eventLocationController.clear();
    eventVM.eventAddressController.clear();
    eventVM.eventDescriptionController.clear();
    eventVM.eventCreditsController.clear();
    eventVM.eventOrganizerController.clear();
    eventVM.city.value = "";
    eventVM.state.value = "";
    eventVM.country.value = "";
    eventVM.event_id.value = "";
    sidebarController.selectedDrawer.value = "Simple";
  }




  @override
  Widget build(BuildContext context) {
    sidebarController.selectedDrawer.value = "Simple";

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: Get.height,
      color: AppColors.blueColor,
      child: Obx((){
        return eventVM.event_id.value != ""
            ? editEvent()
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
                            child: EventCard(
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

  Widget editEvent(){
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
                  "Edit Event",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: headingFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => _pickImage(),
                    child: Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: _image == null ? NetworkImage(eventVM.eventImageController.text) : NetworkImage(""), fit: BoxFit.cover)
                      ),
                      child: _image == null
                          ? SizedBox()
                          : Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: spacing(width)),
                Text('Enter Event Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Event Name", context,eventVM.eventNameController),
                SizedBox(height: spacing(width)),
                Text('Enter Event Organizer',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Event Organizer", context, eventVM.eventOrganizerController),
                SizedBox(height: spacing(width)),
                Text('Enter Event Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Event Address", context, eventVM.eventAddressController),
                SizedBox(height: spacing(width)),
                if(width > 600)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Enter Date',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                                const SizedBox(height: 5),
                                _buildInputField("Event Date", context, eventVM.eventDateController),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing(width)),
                      Expanded(

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                            const SizedBox(height: 5),
                            _buildInputField("Event Price", context, eventVM.eventPriceController, isNumber: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                if(width < 600)
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enter Date',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                          const SizedBox(height: 5),
                          _buildInputField("Event Date", context, eventVM.eventDateController),
                        ],
                      ),
                    ),
                  ),
                if(width < 600)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: spacing(width)),
                      Text('Enter Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                      const SizedBox(height: 5),
                      _buildInputField("Event Price", context, eventVM.eventPriceController, isNumber: true),
                    ],
                  ),
                SizedBox(height: spacing(width)),
                if(width > 600)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Event City, Country',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                            const SizedBox(height: 5),

                            GestureDetector(
                              onTap: (){
                                _openLocationPickerDialog();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.94, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppImages.locationnew,
                                      height: 36,
                                      width: 36,
                                    ),
                                    SizedBox(width: 10),
                                    Obx(
                                          ()=> Expanded(
                                        child: Text( ( eventVM.city.value == "" && eventVM.country.value == "" ) ? "Select City, Country" : '${eventVM.city.value}, ${eventVM.country.value}',
                                          overflow: TextOverflow.ellipsis,
                                          style: jost400(headingFont, Colors.black),
                                        ),
                                      ),
                                    ),

                                    Icon(Icons.arrow_forward_ios, color: Colors.black87, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing(width)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Event Credits',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                            const SizedBox(height: 5),
                            _buildInputField("Event Credits", context, eventVM.eventCreditsController),
                          ],
                        ),
                      ),
                    ],
                  ),
                if(width < 600)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event City, Country',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: (){
                          _openLocationPickerDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.94, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                AppImages.locationnew,
                                height: 36,
                                width: 36,
                              ),
                              SizedBox(width: 10),
                              Obx(
                                    ()=> Expanded(
                                  child: Text( ( eventVM.city.value == "" && eventVM.country.value == "" ) ? "Select City, Country" : '${eventVM.city.value}, ${eventVM.country.value}',
                                    overflow: TextOverflow.ellipsis,
                                    style: jost400(17, Colors.black),

                                  ),
                                ),
                              ),

                              Icon(Icons.arrow_forward_ios, color: Colors.black87, size: 18),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: spacing(width)),
                    ],
                  ),
                if(width < 600)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Event Credits',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                      const SizedBox(height: 5),
                      _buildInputField("Event Credits", context, eventVM.eventCreditsController),
                    ],
                  ),
                SizedBox(height: spacing(width)),
                Text('Enter Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("Event Description", context, eventVM.eventDescriptionController, maxLines: 5),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: (){
                    Start_function();
                  },
                  child: Container(
                    height: 51,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.blueColor, AppColors.lighterBlueColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Edit Event',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
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
