import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/firebase_options.dart';

import 'adminPanel/MainDashboard.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
      // options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 800), // Specify the design size of your UI
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          Get.put(PageController());
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'International week',
            getPages: [
              // GetPage(name: '/', page: () => SplashSreen()),
              GetPage(name: '/', page: () => MainDashboard()),
          // it is for admin panel

            ],
          );
        });
  }
}

