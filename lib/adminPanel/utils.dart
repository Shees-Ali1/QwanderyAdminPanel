import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iw_admin_panel/adminPanel/utils/mediaquery.dart';
import 'package:iw_admin_panel/adminPanel/utils/sizebox_extention.dart';


class MobileBody extends StatefulWidget {
  const MobileBody({super.key});

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  @override
  Widget build(BuildContext context) {
    double screenWidth=context.screenWidth;
    double screenHeight=context.screenHeight;
    return Scaffold(

      // backgroundColor: primaryColor.withOpacity(0.2),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Images/nomad1.png"),
            Container(
              height: screenHeight*0.4,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: adminblack,
                  borderRadius: BorderRadius.circular(10.sp)
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Column(
                  children: [
                    2.height,
                    Text("Admin Login",style: TextStyle(
                        color: whiteColor,fontSize: 20.sp,fontWeight:FontWeight.bold,fontFamily: 'Sora'
                    ),),
                    6.height,
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Sora'
                        ),

                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        suffixIcon: const Icon(Icons.visibility_outlined),
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Sora'
                        ),
                      ),
                    ),
                    3.height,
                    // RoundButton(title: "Login", onTap: (){})


                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
