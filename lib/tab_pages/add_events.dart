import 'dart:typed_data';

import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_admin_panel/const/images.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/controllers/event_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import '../colors.dart';
import 'package:intl/intl.dart';

class AddEvents extends StatefulWidget {
  AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final SidebarController sidebarController = Get.put(SidebarController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EventController eventVM = Get.put(EventController());
  final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance

  Uint8List? _image;


  @override
  void initState(){
    super.initState();
    eventVM.eventLinkController.clear();

    eventVM.eventImageController.clear();
    eventVM.eventNameController.clear();
    eventVM.eventDateController.clear();
    eventVM.eventPriceController.clear();
    eventVM.eventStartPriceController.clear();
    eventVM.eventEndPriceController.clear();
    eventVM.eventLocationController.clear();
    eventVM.eventAddressController.clear();
    eventVM.eventDescriptionController.clear();
    eventVM.eventCreditsController.clear();
    eventVM.eventOrganizerController.clear();
    eventVM.city.value = "City";
    eventVM.state.value = "State";
    eventVM.country.value = "United States";
    eventVM.event_id.value = "";
    eventVM.credits_and_topics.value = [];
    eventVM.multiple_dates.value = [];
  }

  // Add event to Firestore
  Future<void> addEvent() async {

    eventVM.loading.value = true;

    eventVM.eventPriceController.text = "${eventVM.eventStartPriceController.text} - ${eventVM.eventEndPriceController.text}";

    if (eventVM.eventNameController.text.isEmpty ||
        eventVM.eventPriceController.text.isEmpty ||
        eventVM.eventLinkController.text.isEmpty ||
        eventVM.eventDateController.text.isEmpty ||
        eventVM.eventDescriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      eventVM.loading.value = false;
      return;
    }

    if(eventVM.online_event.value == false && eventVM.eventAddressController.text.isEmpty){
      Get.snackbar(
        "Error",
        "All fields are required!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      eventVM.loading.value = false;
      return;
    }

    try {

      String fileName = 'event_pictures/${eventVM.eventNameController.text}.jpg';
      UploadTask uploadTask = _storage.ref(fileName).putData(
        _image!, // Pass the Uint8List directly
        SettableMetadata(contentType: 'image/jpeg'), // Metadata for image
      );
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      final docRef = await _firestore.collection('events').add({
        'event_image': downloadUrl,
        'event_name': eventVM.eventNameController.text.trim(),
        'event_date': eventVM.single_date.value ? eventVM.eventDateController.text.trim() : "",
        'event_price': eventVM.eventPriceController.text.trim(),
        'event_start_price': eventVM.eventStartPriceController.text.trim(),
        'event_end_price': eventVM.eventEndPriceController.text.trim(),
        'event_credits': eventVM.eventCreditsController.text.trim(),
        'event_location': eventVM.eventLocationController.text.trim(),
        'event_building': eventVM.online_event.value == true ? "" : eventVM.eventAddressController.text.trim(),
        'event_description': eventVM.eventDescriptionController.text.trim(),
        'event_link': eventVM.eventLinkController.text.trim(),
        "single_date": eventVM.single_date.value,
        "online_event": eventVM.online_event.value,
        "multiple_event_dates": eventVM.single_date.value ? [] : eventVM.multiple_dates,
        'created_at': FieldValue.serverTimestamp(),
        'planned': [],
        'following': [],
        'favourited': [],
        'attending': [],
        'attended': [],
        'reviews': [],
        "credits_and_topics": eventVM.credits_and_topics,
        "average_rating": 0,
        'event_organizer': eventVM.eventOrganizerController.text.trim(),
      });

      await _firestore.collection('events').doc(docRef.id).update({
        'event_id': docRef.id,
      });


      Get.snackbar(
        "Success",
        "Event added successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );



      // Clear all fields
      eventVM.eventImageController.clear();
      eventVM.eventNameController.clear();
      eventVM.eventLinkController.clear();
      eventVM.eventDateController.clear();
      eventVM.eventPriceController.clear();
      eventVM.eventStartPriceController.clear();
      eventVM.eventEndPriceController.clear();
      eventVM.eventLocationController.clear();
      eventVM.eventAddressController.clear();
      eventVM.eventDescriptionController.clear();
      eventVM.eventCreditsController.clear();
      eventVM.eventOrganizerController.clear();
      eventVM.city.value = "City";
      eventVM.state.value = "State";
      eventVM.country.value = "United States";
      eventVM.online_event.value = false;
      eventVM.multiple_dates.clear();
      eventVM.single_date.value = true;
      eventVM.credits_and_topics.clear();

      setState(() {
        _image = null;
      });

      eventVM.loading.value = false;


    } catch (e) {
      eventVM.loading.value = false;

      debugPrint("Error while posting: $e");
      Get.snackbar(
        "Error",
        "Failed to add event: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent selection of past dates
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

      if (eventVM.single_date.value == true) {
        eventVM.eventDateController.text = formattedDate;
        eventVM.multiple_dates.clear();
      } else {
        if (!eventVM.multiple_dates.contains(formattedDate)) {
          eventVM.multiple_dates.add(formattedDate);
          eventVM.eventDateController.text =
              eventVM.eventDateController.text + formattedDate + ", ";
        }
      }
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
                  defaultCountry: CscCountry.United_States,
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
                    eventVM.eventLocationController.text = "${eventVM.city.value}, ${eventVM.country.value}";
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [AppColors.blueColor, AppColors.greenbutton]),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Enter Details",
                    style: jost600(16, Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter Topic',
                    style: jost500(16, Colors.white),
                  ),
                  SizedBox(height: 15),
                  _buildInputField("Topic",context, eventVM.eventTopicController, isNumber: false),
                  SizedBox(height: 10),
                  Text(
                    'Enter Accreditor',
                    style: jost500(16, Colors.white),
                  ),
                  SizedBox(height: 15),
                  _buildInputField("Accreditor", context, eventVM.eventAccreditorController, isNumber: false),
                  Text(
                    'Enter Credit',
                    style: jost500(16, Colors.white),
                  ),
                  SizedBox(height: 15),
                  _buildInputField("Event Credits", context,eventVM.eventCreditsController, isNumber: true),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: jost500(16, Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (eventVM.eventCreditsController.text.isNotEmpty &&
                              eventVM.eventTopicController.text.isNotEmpty &&
                              eventVM.eventAccreditorController.text.isNotEmpty) {

                            var map = {
                              "topic": eventVM.eventTopicController.text.trim(),
                              "accreditor": eventVM.eventAccreditorController.text.trim(),
                              "credits_earned": double.parse(eventVM.eventCreditsController.text.trim()),
                            };

                            eventVM.credits_and_topics.add(map);
                            debugPrint("Credits: ${eventVM.credits_and_topics}");

                            eventVM.eventCreditsController.clear();
                            eventVM.eventTopicController.clear();
                            eventVM.eventAccreditorController.clear();
                          }

                        },
                        child: Text(
                          "Add",
                          style: jost500(16, Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  @override
  void dispose(){
    super.dispose();
  }

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
                    "Add New Event",
                    style: TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: headingFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => _pickImage(),
                      child: Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.secondaryColor
                        ),
                        child: _image == null
                            ? Icon(Icons.image, size: 40, color: AppColors.blueColor,)
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          ),
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
                  Text('Enter Event Link',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                  const SizedBox(height: 5),
                  _buildInputField("Event Link", context, eventVM.eventLinkController),
                   SizedBox(height: spacing(width)),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Online Event',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                      Spacer(),
                      Text('Yes',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: width < 425 ? headingFont : 15),),
                      Obx(
                            ()=> GestureDetector(
                          onTap: (){
                            eventVM.online_event.value = true;
                          },
                          child: Container(
                            padding: EdgeInsets.all( width <= 1024 && width > 768 ? 5 : width <= 768 && width > 280 ? 4 : 8),
                            margin: EdgeInsets.only(left: 6, right: 10,),
                            decoration: BoxDecoration(
                              color: eventVM.online_event.value == true ? AppColors.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(width <= 1024 && width > 768 ? 9 : width <= 768 && width > 280 ? 6 : 12),
                              border: Border.all(
                                width: 1,
                                color:eventVM.online_event.value == true ? AppColors.primaryColor : Colors.white,
                              ),
                            ),
                            child: Icon(Icons.check, size: width <= 1024 && width > 768 ? 15 : width <= 768 && width > 280 ? 12 : 20, color: eventVM.online_event.value == true ? Colors.white : Colors.transparent,) ,
                          ),
                        ),
                      ),
                      Text('No',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: width < 425 ? headingFont : 15),),
                      Obx(
                            ()=> GestureDetector(
                          onTap: (){
                            eventVM.online_event.value = false;
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 6, right: 0,),
                            padding: EdgeInsets.all( width <= 1024 && width > 768 ? 5 : width <= 768 && width > 280 ? 4 : 8),
                            decoration: BoxDecoration(
                              color: eventVM.online_event.value == false ? AppColors.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(width <= 1024 && width > 768 ? 9 : width <= 768 && width > 280 ? 6 : 12),
                              border: Border.all(
                                width: 1,
                                color:eventVM.online_event.value == false ? AppColors.primaryColor : Colors.white,
                              ),
                            ),
                            child: Icon(Icons.check, size: width <= 1024 && width > 768 ? 15 : width <= 768 && width > 280 ? 12 : 20, color: eventVM.online_event.value == false ? Colors.white : Colors.transparent,) ,
                          ),
                        ),
                      )


                    ],
                  ),
                    Obx(
                      ()=> eventVM.online_event.value == false ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text('Enter Event Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                          const SizedBox(height: 5),
                          _buildInputField("Event Address", context, eventVM.eventAddressController),
                        ],
                      ) : SizedBox(),
                    ),
                  SizedBox(height: spacing(width)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Single Date',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                      Spacer(),
                      Text('Yes',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: width < 425 ? headingFont : 15),),
                      Obx(
                            ()=> GestureDetector(
                          onTap: (){
                            eventVM.single_date.value = true;
                            eventVM.multiple_dates.clear();
                            eventVM.eventDateController.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.all( width <= 1024 && width > 768 ? 5 : width <= 768 && width > 280 ? 4 : 8),
                            margin: EdgeInsets.only(left: 6, right: 10,),
                            decoration: BoxDecoration(
                              color: eventVM.single_date.value == true ? AppColors.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(width <= 1024 && width > 768 ? 9 : width <= 768 && width > 280 ? 6 : 12),
                              border: Border.all(
                                width: 1,
                                color:eventVM.single_date.value == true ? AppColors.primaryColor : Colors.white,
                              ),
                            ),
                            child: Icon(Icons.check, size: width <= 1024 && width > 768 ? 15 : width <= 768 && width > 280 ? 12 : 20, color: eventVM.single_date.value == true ? Colors.white : Colors.transparent,) ,
                          ),
                        ),
                      ),
                      Text('No',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: width < 425 ? headingFont : 15),),
                      Obx(
                            ()=> GestureDetector(
                          onTap: (){
                            eventVM.single_date.value = false;
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 6, right: 0,),
                            padding: EdgeInsets.all( width <= 1024 && width > 768 ? 5 : width <= 768 && width > 280 ? 4 : 8),
                            decoration: BoxDecoration(
                              color: eventVM.single_date.value == false ? AppColors.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(width <= 1024 && width > 768 ? 9 : width <= 768 && width > 280 ? 6 : 12),
                              border: Border.all(
                                width: 1,
                                color:eventVM.single_date.value == false ? AppColors.primaryColor : Colors.white,
                              ),
                            ),
                            child: Icon(Icons.check, size: width <= 1024 && width > 768 ? 15 : width <= 768 && width > 280 ? 12 : 20, color: eventVM.single_date.value == false ? Colors.white : Colors.transparent,) ,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: spacing(width)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Enter Date',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                                  Obx(()=> eventVM.single_date.value == false ? GestureDetector(
                                      onTap: (){
                                        _selectDate(context);
                                      },
                                      child: Icon(CupertinoIcons.plus, size: 20, color: Colors.white,)): SizedBox()) ,
                                ],
                              ),
                              const SizedBox(height: 5),
                              Obx((){
                                if(eventVM.single_date.value == true){
                                  return GestureDetector(
                                    onTap: (){
                                      _selectDate(context);
                                    },
                                    child: AbsorbPointer(
                                        child: _buildInputField("Event Date", context, eventVM.eventDateController)),
                                  );
                                } else if(eventVM.single_date.value == false && eventVM.multiple_dates.isNotEmpty){
                                  return SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                        itemCount: eventVM.multiple_dates.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index){
                                          return Container(
                                            width: 120,
                                            padding: EdgeInsets.all(8),
                                            margin: EdgeInsets.only(left: index != 0 ? 10 : 0,),
                                            decoration: BoxDecoration(
                                              color: AppColors.blueColor,
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    eventVM.multiple_dates.remove(eventVM.multiple_dates[index]);
                                                  },
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: Icon(CupertinoIcons.minus_circle_fill, size: 20, color: Colors.white,),
                                                  ),
                                                ),
                                                Text(eventVM.multiple_dates[index], style: jost500(15, Colors.white),)
                                              ],
                                            ),
                                          );
                                        }),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if(width > 600)
                  Column(
                    children: [

                      SizedBox(height: spacing(width)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Enter Starting Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                                const SizedBox(height: 5),
                                _buildInputField("Event Price", context, eventVM.eventStartPriceController, isNumber: true),
                              ],
                            ),
                          ),
                          SizedBox(width: spacing(width),),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text('Enter Ending Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                                const SizedBox(height: 5),
                                _buildInputField("Event Price", context, eventVM.eventEndPriceController, isNumber: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: spacing(width)),
                  if(width < 600)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Enter Starting Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                              const SizedBox(height: 5),
                              _buildInputField("Event Price", context, eventVM.eventStartPriceController, isNumber: true),
                            ],
                          ),
                        ),
                        SizedBox(width: spacing(width),),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text('Enter Ending Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                              const SizedBox(height: 5),
                              _buildInputField("Event Price", context, eventVM.eventEndPriceController, isNumber: true),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                                          style: jost400(17, Colors.black),
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
                      ]
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
                                       style: jost400(width < 425 ? headingFont : 17, Colors.black),

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
                  SizedBox(height: spacing(width)),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Enter Event Topics & Credits',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                      GestureDetector(
                        onTap: (){
                          _showCreditDialog(context);
                        },
                          child: Icon(CupertinoIcons.plus, size: 20, color: Colors.white,))
                    ],
                  ),
                  Obx((){
                    if(eventVM.credits_and_topics.isNotEmpty){
                      return SizedBox(
                        height: 145,
                        child: ListView.builder(
                          itemCount: eventVM.credits_and_topics.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                          return Container(
                            width: 200,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(left: index != 0 ? 10 : 0,),
                            decoration: BoxDecoration(
                              color: AppColors.blueColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    eventVM.credits_and_topics.removeWhere((credit)=> credit["topic"] == eventVM.credits_and_topics[index]["topic"]);
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(CupertinoIcons.minus_circle_fill, size: 20, color: Colors.white,),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Topic:", style: jost500(15, Colors.white),),
                                    Text(eventVM.credits_and_topics[index]["topic"], style: jost500(12, Colors.white),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Accreditor:", style: jost500(15, Colors.white),),
                                    Text(eventVM.credits_and_topics[index]["accreditor"], style: jost500(12, Colors.white),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Credits:", style: jost500(15, Colors.white),),
                                    Text(eventVM.credits_and_topics[index]["credits_earned"].toString(), style: jost500(12, Colors.white),),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    } else {
                     return SizedBox();
                    }
                  }),
                  SizedBox(height: spacing(width)),
                  Text('Enter Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                  const SizedBox(height: 5),
                  _buildInputField("Event Description", context, eventVM.eventDescriptionController, maxLines: 5),
                  const SizedBox(height: 30),
                  Obx(
                     ()=> GestureDetector(
                       onTap: (){
                         if(eventVM.csv_loading.value != true || eventVM.loading.value != true){
                           addEvent();
                         }
                       },
                      child: Container(
                        height: 51,
                        width: double.infinity,
                       // padding: EdgeInsets.symmetric(vertical: 8.h),
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
                        child:  Center(
                          child: eventVM.loading.value == true
                              ? CircularProgressIndicator(color: Colors.white,)
                              : Text(
                            'Add Event',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                        ()=> GestureDetector(
                      onTap: (){
                        if(eventVM.csv_loading.value != true || eventVM.loading.value != true){
                          eventVM.pickAndExtractCsv();
                        }
                      },
                      child: Container(
                        height: 51,
                        width: double.infinity,
                        // padding: EdgeInsets.symmetric(vertical: 8.h),
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
                        child:  Center(
                          child: eventVM.loading.value == true
                              ? CircularProgressIndicator(color: Colors.white,)
                              : Text(
                            'Use CSV',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
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
        hintStyle:  jost400(17, Colors.black),
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
