import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';
import '../colors.dart';
import 'package:intl/intl.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SidebarController sidebarController = Get.put(SidebarController());

  // Form controllers
  final TextEditingController eventImageController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventPriceController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();

  // Add event to Firestore
  Future<void> addEvent() async {
    if (eventNameController.text.isEmpty ||
        eventImageController.text.isEmpty ||
        eventDateController.text.isEmpty ||
        eventPriceController.text.isEmpty ||
        eventLocationController.text.isEmpty ||
        eventAddressController.text.isEmpty ||
        eventDescriptionController.text.isEmpty) {
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
      double? price = double.tryParse(eventPriceController.text);
      if (price == null) {
        Get.snackbar("Error", "Invalid price");
        return;
      }

      final docRef = await _firestore.collection('events').add({
        'event_image': eventImageController.text,
        'event_name': eventNameController.text,
        'event_date': eventDateController.text,
        'event_price': price,
        'event_credits': '',
        'event_location': eventLocationController.text,
        'event_address': eventAddressController.text,
        'event_description': eventDescriptionController.text,
        'created_at': FieldValue.serverTimestamp(),
        'planned': [],
        'following': [],
        'favourited': [],
        'attending': [],
        'attended': [],
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
      eventImageController.clear();
      eventNameController.clear();
      eventDateController.clear();
      eventPriceController.clear();
      eventLocationController.clear();
      eventAddressController.clear();
      eventDescriptionController.clear();
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
          data: ThemeData.light().copyWith(
            primaryColor: Colors.white, // Color of the header (month/year)
            hintColor: Colors.blue,   // Accent color (selection)
            dialogBackgroundColor: Colors.blue, // Background color of the calendar
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Text color of the buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      // Format the selected date to your desired format
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      eventDateController.text = formattedDate; // Display the formatted date in the controller
    }
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
            horizontal: width < 768 ? 40 : 460,
            vertical: height < 768 ? 10 : 95,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 700), // Max width 700px
            child: Column(
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
                const SizedBox(height: 25),
                Text(
                  "Add New Event",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25),
                Text('Enter Event Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Name", eventNameController),
                const SizedBox(height: 20),
                Text('Enter Image URL',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Image URL", eventImageController),
                const SizedBox(height: 20),

                const SizedBox(height: 5),
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
                              _buildInputField("Event Date", eventDateController),
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
                          _buildInputField("Event Price", eventPriceController, isNumber: true),
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
                          Text('Event Location',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                          const SizedBox(height: 5),
                          _buildInputField("Event Location", eventLocationController),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enter Event Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                          const SizedBox(height: 5),
                          _buildInputField("Event Address", eventAddressController),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Enter Description',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),),
                const SizedBox(height: 5),
                _buildInputField("Event Description", eventDescriptionController, maxLines: 5),
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
