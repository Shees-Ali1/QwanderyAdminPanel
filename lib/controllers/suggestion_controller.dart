import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController correctionsController = TextEditingController();
  final TextEditingController sugguestNewController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();

  var suggestion_id = ''.obs;
  var view = false.obs;
}