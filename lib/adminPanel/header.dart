
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iw_admin_panel/adminPanel/utils/mediaquery.dart';
import 'package:iw_admin_panel/adminPanel/utils/responsive1.dart';

import 'AdminLoginview.dart';


class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(

        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
                icon: const Icon(Icons.menu),
                onPressed: (){}
              // context.read<MenuAppController>().controlMenu,
            ),
          if (!Responsive.isMobile(context))
            Image.asset('assets/images/iw-logo.png',
              height: 88.h,
              width: 46.w,
            ),
          // Text(
          //   "Dashboard",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 10.sp,
          //     color: primaryColor,decoration: TextDecoration.underline,decorationColor: primaryColor
          //   ),
          // ),
          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          // Expanded(child: SearchField()),
          // const ProfileCard(),
          Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: primaryColoradmin,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                GestureDetector(onTap: (){
                  FirebaseAuth.instance.signOut().then((value){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AdminLoginView()), (route) => false);
                  });
                }, child: Icon(Icons.logout,color: whiteColor,)),
                if (!Responsive.isMobile(context))
                  const Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal:8),
                    child: Text("Logout",style: TextStyle(
                      color: whiteColor,
                    ),),
                  ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: primaryColoradmin,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage('assets/Images/logoprofile.png'), fit: BoxFit.cover)
            ),

          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding:
              EdgeInsets.symmetric(horizontal:8),
              child: Text("Admin",style: TextStyle(
                color: adminblack,
              ),),
            ),

        ],
      ),
    );
  }
}
