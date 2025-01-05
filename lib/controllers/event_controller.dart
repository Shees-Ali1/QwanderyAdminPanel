import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart'; // Add csv package
import 'dart:typed_data';
import 'package:intl/intl.dart'; // For date formatting


class EventController extends GetxController {
  RxString city = "City".obs;
  RxString state = "State".obs;
  RxString country = "United States".obs;
  RxString event_id = "".obs;
  RxBool loading = false.obs;
  RxBool csv_loading = false.obs;
  RxBool online_event = false.obs;
  RxBool single_date = true.obs;
  var multiple_dates = [].obs;
  var credits_and_topics = [].obs;

  // Form controllers
  final TextEditingController eventImageController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventLinkController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventPriceController = TextEditingController();
  final TextEditingController eventStartPriceController = TextEditingController();
  final TextEditingController eventEndPriceController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventCreditsController = TextEditingController();
  final TextEditingController eventTopicController = TextEditingController();
  final TextEditingController eventAccreditorController = TextEditingController();
  final TextEditingController eventOrganizerController = TextEditingController();

  Future<void> pickAndExtractCsv() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        // Extract the file as bytes
        Uint8List fileBytes = result.files.single.bytes!;
        String fileContent = String.fromCharCodes(fileBytes);

        // Parse CSV data into a list of rows
        List<List<dynamic>> rawData = CsvToListConverter(eol: '\n', fieldDelimiter: ',', shouldParseNumbers: false).convert(fileContent);

        debugPrint("Raw Data After Skipping Headings: $rawData");

        // Parse event data
        List<Map<String, dynamic>> parsedEvents = parseEventData(rawData);
        debugPrint("Parsed Events: $parsedEvents");

        await uploadEventsToFirebase(parsedEvents);
      } else {
        debugPrint("File picking canceled.");
      }
    } catch (e) {
      debugPrint("Error picking or processing the file: $e");
    }
  }

  List<Map<String, dynamic>> parseEventData(List<List<dynamic>> rawData) {
    List<Map<String, dynamic>> parsedEvents = [];

    if (rawData.isEmpty) {
      debugPrint("No data found.");
      return parsedEvents;
    }

    for (var row in rawData) {
      if (row.isEmpty) {
        debugPrint("Skipping empty row.");
        continue;
      }

      try {
        // Helper function to parse dates
        List<String> parseDates(String dateValue) {
          return dateValue
              .split(',')
              .map((date) => DateFormat("yyyy-MM-dd").format(DateFormat("d MMM yyyy").parse(date.trim())))
              .toList();
        }

        // Helper function to parse credits and topics
        List<Map<String, dynamic>> parseCreditsAndTopics(String credits, String topics, String extra) {
          List<String> topic = topics.split(',').map((item) => item.trim()).toList();
          List<String> accreditor = credits.split(',').map((item) => item.trim()).toList();
          List<String> creditsEarned = extra.split(',').map((item) => item.trim()).toList();

          int maxLength = [topic.length, accreditor.length, creditsEarned.length].reduce((a, b) => a > b ? a : b);

          List<Map<String, dynamic>> result = [];
          for (int i = 0; i < maxLength; i++) {
            result.add({
              'topic': i < topic.length ? topic[i] : "",
              'accreditor': i < accreditor.length ? accreditor[i] : "",
              'credits_earned': i < creditsEarned.length ? double.tryParse(creditsEarned[i]) ?? 0 : 0,
            });
          }
          return result;
        }

        // Parse the row
        bool singleDate = row[6].toString().toLowerCase() == "true";
        List<String> eventDates = parseDates(row[7].toString()); // Parse dates from the 8th index

        // Parse credits and topics
        List<Map<String, dynamic>> creditsAndTopics = parseCreditsAndTopics(
          row[11].toString(), // Topics
          row[12].toString(), // Accreditor
          row[13].toString(), // Credits
        );

        Map<String, dynamic> event = {
          'event_image': row[0].toString().trim(),
          'event_name': row[1].toString().trim(),
          'event_organizer': row[2].toString().trim(),
          'event_link': row[3].toString().trim(),
          'online_event': row[4].toString().toLowerCase() == "true",
          'event_building': row[5].toString().trim() == "No Address" ? "" : row[5].toString().trim(),
          'single_date': singleDate,
          'event_date': singleDate ? "" : eventDates[0], // Add parsed dates here
          "event_price": "${row[8].toString().trim()}-${row[9].toString().trim()}",
          'event_start_price': row[8].toString().trim(),
          'event_end_price': row[9].toString().trim(),
          'event_location': row[10].toString().trim(),
          'event_description': row[11].toString().trim(),
          'created_at': FieldValue.serverTimestamp(),
          "multiple_event_dates": singleDate ? [] : eventDates,
          "credits_and_topics": creditsAndTopics, // Add parsed credits and topics
          'planned': [],
          'following': [],
          'favourited': [],
          'attending': [],
          'attended': [],
          'reviews': [],
          "event_credits": "",
          "average_rating": 0,
        };

        parsedEvents.add(event);
      } catch (e) {
        debugPrint("Error parsing row: $row. Error: $e");
      }
    }

    return parsedEvents;
  }

  int _parseInt(dynamic value) {
    if (value is int) {
      return value; // If already an integer, return it as is
    } else if (value is String) {
      try {
        return int.parse(value.trim());
      } catch (e) {
        return 0; // If parsing fails, return 0 as default
      }
    }
    return 0; // Return 0 for invalid types
  }


// Helper function to process credits_and_topics
  List<Map<String, dynamic>> _processCreditsAndTopics(List<dynamic> row) {
    List<Map<String, dynamic>> creditsAndTopics = [];

    // Ensure there are enough fields in the row to process credits and topics
    if (row.length >= 13) {
      // Split the string values by ", " and map them into a list
      List<String> creditTopics = row[11]?.toString().split(', ') ?? [];
      List<String> topics = row[12]?.toString().split(', ') ?? [];
      List<String> descriptions = row[13]?.toString().split(', ') ?? [];

      // Make sure all lists are of equal length
      int length = [creditTopics.length, topics.length, descriptions.length].reduce((a, b) => a < b ? a : b);

      // Create maps by combining the corresponding values
      for (int i = 0; i < length; i++) {
        creditsAndTopics.add({
          'credit_topic': creditTopics[i]?.trim() ?? "",
          'topic': topics[i]?.trim() ?? "",
          'description': descriptions[i]?.trim() ?? "",
        });
      }
    }

    return creditsAndTopics;
  }

  // Upload parsed events to Firebase
  Future<void> uploadEventsToFirebase(List<Map<String, dynamic>> events) async {
    final firestore = FirebaseFirestore.instance;

    for (var event in events) {
      try {
        DocumentReference docRef = await firestore.collection('events').add(event);
        await docRef.update({'event_id': docRef.id});
        debugPrint("Successfully uploaded event: ${docRef.id}");
      } catch (e) {
        debugPrint("Error uploading event: $event. Error: $e");
      }
    }
  }
}
