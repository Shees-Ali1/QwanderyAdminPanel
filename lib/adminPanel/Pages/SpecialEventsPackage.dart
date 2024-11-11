import 'dart:html' as html;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../GoogleMap/google.dart';
import 'GoogleMapWeb.dart';


class SpecialEventPackages extends StatefulWidget {
  const SpecialEventPackages({Key? key}) : super(key: key);

  @override
  State<SpecialEventPackages> createState() => _SpecialEventPackagesState();
}

class _SpecialEventPackagesState extends State<SpecialEventPackages> {
  bool _isUploading = false; // Add this variable to track whether data is being uploaded

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Map<String, dynamic>? selectedEventData;
  String eventImageURL = '';
  String logoImageURL = '';
  TextEditingController eventDetailsController = TextEditingController(),
      organizerNameController = TextEditingController(),
      priceController = TextEditingController(),
      dateController = TextEditingController(),
      timeController = TextEditingController(),
      locationController = TextEditingController();

  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController packageHeadline = TextEditingController();
  TextEditingController packageDetails = TextEditingController();
  TextEditingController packageDiscounted = TextEditingController();
  TextEditingController packagePrice = TextEditingController();



  void _showUploadSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Successful'),
          content: Text('Your event has been uploaded successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Future<Map<String, dynamic>> fetchCoordinates(String address) async {
    final apiKey = 'AIzaSyCvlE2XcxEXl5B3nrOQkwlkQ4Wnn_8oUPI';
    final encodedAddress = Uri.encodeQueryComponent(address);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      }
    }
    throw Exception('Failed to fetch coordinates for the provided address.');
  }

  Future<void> uploadUpcomingEvents({
    String? eventImageURL,
    String? logoImageURL,
  }) async {
    try {
      if (organizerNameController.text.isEmpty ||
          eventDetailsController.text.isEmpty ||
          priceController.text.isEmpty ||
          discountedPriceController.text.isEmpty ||
          dateController.text.isEmpty ||
          aboutController.text.isEmpty ||
          timeController.text.isEmpty ||
          categoryController.text.isEmpty ||
          packageHeadline.text.isEmpty ||
          packageDetails.text.isEmpty ||
          packagePrice.text.isEmpty ||
          packageDiscounted.text.isEmpty ||
          locationController.text.isEmpty ||
          eventImageURL == null || // Assuming you have the URL for the event image
          logoImageURL == null) { // Check if logo image is provided) {
        return;
      }
      final coordinates = await fetchCoordinates(locationController.text);
      final double latitude = coordinates['latitude'];
      final double longitude = coordinates['longitude'];

      String eventId = Uuid().v4();
      await _firestore.collection('specialPackages').add({
        'eventId': eventId,
        'organizerName': organizerNameController.text,
        'eventDetails': eventDetailsController.text,
        'price': priceController.text,
        'discountedPrice': discountedPriceController.text,
        'date': dateController.text,
        'time': timeController.text,
        'location': locationController.text,
        'latitude': latitude, // Add latitude to Firestore
        'longitude': longitude, // Add longitude to Firestore
        'eventImage': eventImageURL, // Add event image URL
        'logoImage': logoImageURL, // Add logo image URL
        'packageHeadline': packageHeadline.text,
        'about': aboutController.text,
        'packageDetail': packageDetails.text,
        'category': categoryController.text,
        'packagePrice': packagePrice.text,
        'packageDiscounted': packageDiscounted.text,

        'timestamp': FieldValue.serverTimestamp(),
      });
      _showUploadSuccessDialog(context);
      organizerNameController.clear();
      eventDetailsController.clear();
      priceController.clear();
      aboutController.clear();
      discountedPriceController.clear();
      dateController.clear();
      timeController.clear();
      locationController.clear();
      categoryController.clear();

      eventImageURL = '';
      logoImageURL = '';


      packageHeadline.clear();
      packageDetails.clear();
      packagePrice.clear();
      packageDiscounted.clear();

      // Clear image file names

    } catch (error) {
      print('Error $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload data: $error'),
        ),
      );
    }
  }


  Future<String> uploadImageEvents(html.File imageFile) async {
    final url = html.Url.createObjectUrlFromBlob(imageFile);

    Reference ref = _storage.ref().child('event_images').child(imageFile.name);
    UploadTask uploadTask = ref.putBlob(imageFile);
    TaskSnapshot snapshot = await uploadTask;

    // Revoke the blob URL after uploading
    html.Url.revokeObjectUrl(url);

    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadImage(html.File imageFile) async {
    final url = html.Url.createObjectUrlFromBlob(imageFile);

    Reference ref = _storage.ref().child('logo_images').child(imageFile.name);
    UploadTask uploadTask = ref.putBlob(imageFile);
    TaskSnapshot snapshot = await uploadTask;

    html.Url.revokeObjectUrl(url);

    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 41, 41, 1),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Special Event Package',
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ),

              SizedBox(
                height: 160,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('UpcomingEventData')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 30,
                          ),
                        );
                      }
                      final List<DocumentSnapshot<Map<String, dynamic>>> upcomingEventsData = snapshot.data!.docs;
                      return ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(), // Set your custom scroll behavior here
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingEventsData.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> upcoming = upcomingEventsData[index].data()!;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0,left: 20),
                              child: GestureDetector(
                                onTap: () {
                                  String organizerName = upcoming['organizerName'] ?? '';
                                  String eventDetails = upcoming['eventDetails'] ?? '';
                                  String price = upcoming['price'] ?? '';
                                  String location = upcoming['location'] ?? '';
                                  String date = upcoming['date'] ?? '';
                                  String time = upcoming['time'] ?? '';
                                  String category = upcoming['category'] ?? '';
                                  String about = upcoming['about'] ?? '';

                                  // Set the extracted data into the text controllers
                                  organizerNameController.text = organizerName;
                                  eventDetailsController.text = eventDetails;
                                  priceController.text = price;
                                  locationController.text = location;
                                  dateController.text =date;
                                  aboutController.text = about;
                                  timeController.text = time;
                                  categoryController.text = category;
                                  eventImageURL = upcoming['eventImage'] ?? '';
                                  logoImageURL = upcoming['logoImage'] ?? '';
                                },
                                child: Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromRGBO(255, 180, 91, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(upcoming['eventImage'] ?? '',
                                              fit: BoxFit.cover,
                                              width: 95,
                                              height: 95),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipOval( // Wrap the Image.network widget with ClipOval
                                                      child: Image.network(
                                                        upcoming['logoImage'] ?? '',
                                                        fit: BoxFit.cover,
                                                        filterQuality: FilterQuality.high,
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(width: 10),
                                                  // Added SizedBox for spacing
                                                  Expanded(
                                                    // Wrap Text with Expanded to prevent overflow
                                                    child: Text(
                                                      upcoming['organizerName'] ?? '',
                                                      style: GoogleFonts.jost(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                height: 40,
                                                child: Text(
                                                  upcoming['eventDetails'] ?? '',
                                                  maxLines: 2,
                                                  style: GoogleFonts.jost(
                                                    fontSize: 14,

                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        '\$${upcoming['price'] ?? ''}', // Show the price if available
                                                        style: GoogleFonts.jost(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          color: Color.fromRGBO(238, 98, 36, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            'Click to Add',
                                                            style: GoogleFonts.jost(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 15,
              ),




              Row(
                children: [
                  buildTextField('Organizer Name', organizerNameController, readOnly: true),
                  buildTextField('Event Category', categoryController, readOnly: true),
                ],
              ),
              Row(
                children: [
                  buildTextField('Event Details', eventDetailsController, readOnly: true),
                  buildTextField('Location', locationController, readOnly: true),

                ],
              ),

              Row(
                children: [
                  buildTextField('Price', priceController, addDollarSign: true, readOnly: true),
                  buildTextField('Discounted Price', discountedPriceController, addDollarSign: true),
                ],
              ),
              Row(
                children: [
                  buildTextField('Date', dateController, readOnly: true),


                  buildTextField('Time', timeController, readOnly: true),


                ],
              ),
              Container(
                  width: double.infinity,
                  child: buildTextField('About Event', aboutController, readOnly: true)),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Additional Package Details',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700, fontSize: 18),),
              ),
              Row(
                children: [
                  buildTextField('Headline', packageHeadline),
                  buildTextField('package Details', packageDetails),
                ],
              ),
              Row(
                children: [
                  buildTextField('Package Price', packagePrice),
                  buildTextField('Package Discount', packageDiscounted),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  child:ElevatedButton(
                    onPressed: () {
                      // Check if all fields are filled
                      if (
                      discountedPriceController.text.isEmpty ||
                          packageHeadline.text.isEmpty ||
                          packageDetails.text.isEmpty ||
                          packagePrice.text.isEmpty ||
                          packageDiscounted.text.isEmpty
                      ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return; // Stop further execution
                      }
                      // Set _isUploading to true to show loader
                      setState(() {
                        _isUploading = true;
                      });
                      // Call the upload function with all required parameters
                      uploadUpcomingEvents(
                        eventImageURL: eventImageURL,
                        logoImageURL: logoImageURL,
                      ).then((_) {
                        // Set _isUploading to false when upload is complete
                        setState(() {
                          _isUploading = false;
                        });
                      }).catchError((error) {
                        // Handle errors during upload
                        print('Error during upload: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to upload data: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        // Set _isUploading to false on error
                        setState(() {
                          _isUploading = false;
                        });
                      });
                    },
                    child: _isUploading
                        ? CircularProgressIndicator() // Show loader if uploading
                        : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Add Your Event',style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 20),),
                    ), // Show button text if not uploading
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTextFieldWithImage(
      String labelText,
      TextEditingController controller,
      String imageUrl,
      {bool addDollarSign = false, String? errorText, bool readOnly = false}
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        children: [
          // Image
          SizedBox(
            width: 50,
            height: 50,
            child: Image.network(imageUrl), // Replace imageUrl with the actual URL of the image
          ),
          SizedBox(width: 10),
          // Text Field
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.17)),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: errorText, // Display error text if it's not null
                prefixText: addDollarSign ? '\$' : null, // Prefix with dollar sign if required
                prefixStyle: TextStyle(color: Colors.black),
                filled: true, // Add this line to enable filling the background
                fillColor: Colors.brown.shade300,
              ),
              readOnly: readOnly, // Set text field as read-only if readOnly is true
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller, {bool addDollarSign = false, String? errorText, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: SizedBox(
        width: 350,
        child: TextField(
          controller: controller,

          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.17)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: errorText, // Display error text if it's not null
            prefixText: addDollarSign ? '\$' : null, // Prefix with dollar sign if required
            prefixStyle: TextStyle(color: Colors.black),
            filled: true, // Add this line to enable filling the background
            fillColor: Colors.brown.shade300,
          ),
          // onTap: onTap, // Call the onTap function when the text field is tapped
          // readOnly: onTap != null, // Make the text field read-only if onTap is provided
          readOnly: readOnly,
        ),
      ),
    );
  }




}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // Add other devices if needed
  };
}









// Widget buildDropdownField(String labelText, TextEditingController controller) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
//     child: SizedBox(
//       width: 350,
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('categories').doc('0Z5MCvrweqyhFRgHdl0n').snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//
//           if (!snapshot.hasData || snapshot.data!.data() == null) {
//             return Text('No categories found');
//           }
//
//           var categoryData = snapshot.data!.data() as Map<String, dynamic>;
//           List<dynamic>? categories = categoryData['categories'] as List<dynamic>?;
//
//           if (categories == null || categories.isEmpty) {
//             return Text('No categories found');
//           }
//
//           return DropdownButtonFormField(
//             decoration: InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 20),
//               labelText: labelText,
//               labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.withOpacity(0.17)),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               filled: true, // Add this line to enable filling the background
//               fillColor: Colors.brown.shade300,
//             ),
//             value: controller.text.isEmpty ? null : controller.text,
//             items: categories.map<DropdownMenuItem<dynamic>>((dynamic category) {
//               return DropdownMenuItem<dynamic>(
//                 value: category['name'],
//                 child: Text(category['name']),
//               );
//             }).toList(),
//             onChanged: (dynamic value) {
//               // Handle when a new value is selected
//               controller.text = value.toString();
//             },
//           );
//         },
//       ),
//     ),
//   );
// }

// buildDropdownField('Event Category', categoryController),