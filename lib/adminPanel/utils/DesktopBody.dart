import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iw_admin_panel/adminPanel/utils/sizebox_extention.dart';
import 'package:iw_admin_panel/adminPanel/utils/snackmessage.dart';
import '../MainDashboard.dart';
import 'mediaquery.dart';
class DesktopBody extends StatefulWidget {
  const DesktopBody({super.key});

  @override
  State<DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {
  @override
  Widget build(BuildContext context) {

    double screenWidth=context.screenWidth;
    double screenHeight=context.screenHeight;
    final emailController=TextEditingController();
    final passwordController=TextEditingController();
    final _key=GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: primaryColoradmin.withOpacity(0.2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/iw-logo.png",height: screenHeight *0.2,width: screenWidth * 0.2)),
          Container(
            height: screenHeight*.50,
            width: screenWidth* .30,
            decoration: BoxDecoration(
                color: primaryColoradmin,
                borderRadius: BorderRadius.circular(8.sp)
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Admin Login",style: TextStyle(
                        color: whiteColor,fontSize: 5.sp,fontWeight:FontWeight.bold,fontFamily: 'Sora'
                    ),),
                    6.height,
                    TextFormField(
                      style: TextStyle(
                          color: whiteColor
                      ),
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined,color: whiteColor,),
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontSize: 2.5.sp,
                            fontFamily: 'Sora',
                            color: whiteColor
                        ),

                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Field can't be empty";
                        }
                        if(value!='iw01@gmail.com'){
                          return "Invalid admin email";
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      style: TextStyle(
                          color: whiteColor
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open_outlined,color: whiteColor,),
                        suffixIcon: const Icon(Icons.visibility_outlined,color: whiteColor,),
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 2.5.sp,
                            fontFamily: 'Sora',
                            color: whiteColor
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Field can't be empty";
                        }
                      },
                    ),
                    10.height,
                    InkWell(
                      onTap: (){
                        if(_key.currentState!.validate()){
                          FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim()).then((value) {
                            // AdminServices.assignAdminRole("hello@smile-mc.co.uk");
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>MainDashboard()));
                          }).onError((error, stackTrace){
                            Utils.toastMessage(error.toString(), Colors.red);
                          });
                        }

                      },
                      child: Container(
                        height: screenHeight *0.05,
                        width: screenWidth * 0.07,
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(4.sp)
                        ),
                        child: const Center(
                          child: Text("Login",style: TextStyle(color: primaryColoradmin),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
