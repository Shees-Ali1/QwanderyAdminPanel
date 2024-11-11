import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import 'mediaquery.dart';

class Utils{
  //static String googleApiKey='AIzaSyB-p7r6-G6ZT_6K1AudkhV1_TGqa7dSDKM';
  //static String googleApiKey='AIzaSyDkWf04MQ9Qi7lqEfFVHN2g1WvvaYOCsjM';
  static String googleApiKey='AIzaSyC3uz4DKrTxvsVrntGesQSQTuLB1uBak8U';

  static toastMessage(String message,Color color){
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT
    );
  }

  static alert(BuildContext context){
    QuickAlert.show(context: context,
      type: QuickAlertType.warning,
      title: 'Please select date',
      confirmBtnColor: primaryColor,
      headerBackgroundColor: primaryColor,


    );
  }
  static void showSnackBar(BuildContext context, String message,Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,

      ),
    );
  }

  static void showCustomSnackBar(String message,Color bgColor,String title,
      {SnackPosition position = SnackPosition.TOP,
        Duration duration = const Duration(seconds: 3)}) {
    Get.snackbar(title, message,
        snackPosition: position,
        duration: duration,
        colorText: Colors.white,
        backgroundColor: bgColor,
        snackStyle: SnackStyle.FLOATING);
  }

}