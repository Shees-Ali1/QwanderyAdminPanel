import 'dart:typed_data';

import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
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

  Uint8List? _image;


  @override
  void initState(){
    super.initState();
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
  }

  // Add event to Firestore
  Future<void> addEvent() async {
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

      final docRef = await _firestore.collection('events').add({
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
      });

      await _firestore.collection('events').doc(docRef.id).update({
        'event_id': docRef.id,
      });


      Get.snackbar(
        "Success",
        "Event added successfully!",
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
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add event: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

    return Scaffold(
      backgroundColor: AppColors.blueColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width <= 768 ? 40 : width <= 1024 ? 200 : width <= 1440 ? 300  : 460,
            vertical: height < 768 ? 10 : 40,
          ),
          child: Container(
            width: width <= 1024 ? 900 : 900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                if (Get.width < 768)
                  GestureDetector(
                    onTap: () {
                      sidebarController.showsidebar.value = true;
                    },
                    child: SvgPicture.asset(
                      'assets/drawernavigation.svg',
                      color: AppColors.backgroundColor,
                    ),
                  ),
                Text(
                  "Add New Event",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => _pickImage(),
                    child: Container(
                      height: 106,
                      width: 106,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image == null
                          ? Image.network(eventVM.eventImageController.text, fit: BoxFit.contain)
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text('Enter Event Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Name", eventVM.eventNameController),
                const SizedBox(height: 20),
                Text('Enter Event Organizer',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Organizer", eventVM.eventOrganizerController),
                const SizedBox(height: 20),
                Text('Enter Event Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Address", eventVM.eventAddressController),
                const SizedBox(height: 20),
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
                              Text('Enter Date',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                              const SizedBox(height: 5),
                              _buildInputField("Event Date", eventVM.eventDateController),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enter Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                          const SizedBox(height: 5),
                          _buildInputField("Event Price", eventVM.eventPriceController, isNumber: true),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event City, Country',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enter Event Credits',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                          const SizedBox(height: 5),
                          _buildInputField("Event Credits", eventVM.eventCreditsController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Enter Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Description", eventVM.eventDescriptionController, maxLines: 5),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: addEvent,
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
                        'Add Event',
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
      TextEditingController controller, {
        bool isNumber = false,
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: null, // Removes the label text
        hintText: null,  // Ensures there's no hint text inside the field
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
