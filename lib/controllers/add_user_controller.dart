import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddUserController extends GetxController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  RxString role = "User".obs;
  RxBool showRole = false.obs;
  RxBool loading = false.obs;

  var roles = [
    "User",
    "Admin",
  ];

  // void init(){
  //   super.onInit();
  //   role.value = "User";
  //   showRole.value = false;
  // }

}