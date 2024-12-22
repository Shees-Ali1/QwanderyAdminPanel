import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController{
  RxString city = "".obs;
  RxString state = "".obs;
  RxString country = "".obs;
  RxString event_id = "".obs;
  RxBool loading = false.obs;



  // Form controllers
  final TextEditingController eventImageController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventPriceController = TextEditingController();
  final TextEditingController eventStartPriceController = TextEditingController();
  final TextEditingController eventEndPriceController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();
  final TextEditingController eventCreditsController = TextEditingController();
  final TextEditingController eventOrganizerController = TextEditingController();
}