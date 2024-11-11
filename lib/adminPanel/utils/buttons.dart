// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import '../const.dart';
import 'mediaquery.dart';

class Button extends StatefulWidget {
  final String buttonText;
  const Button({super.key, required this.buttonText});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      height: 48,
      decoration: const BoxDecoration(
          color: button2, borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: textcolor,
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class Button2 extends StatefulWidget {
  final String buttonText;
  const Button2({super.key, required this.buttonText});

  @override
  State<Button2> createState() => _Button2State();
}

class _Button2State extends State<Button2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 279,
      height: 48,
      decoration: const BoxDecoration(
          color: button2, borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: textcolor,
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class skip_button extends StatefulWidget {
  final String buttonText;
  const skip_button({super.key, required this.buttonText});

  @override
  State<skip_button> createState() => _skip_buttonState();
}

class _skip_buttonState extends State<skip_button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      height: 48,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 228, 233, 1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: const Color(0xffAE9C7F), width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: button2,
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class ButtonSkip extends StatefulWidget {
  final String buttonText;
  const ButtonSkip({super.key, required this.buttonText});

  @override
  State<ButtonSkip> createState() => _ButtonSkipState();
}

class _ButtonSkipState extends State<ButtonSkip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      height: 48,
      decoration: BoxDecoration(
          color:  const Color.fromRGBO(248, 248, 248, 1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: const Color(0xffAE9C7F), width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: button2,
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class main_button extends StatefulWidget {
  final String buttonText;
  final double? width;
  main_button({super.key, required this.buttonText,this.width});

  @override
  State<main_button> createState() => _main_buttonState();
}

class _main_buttonState extends State<main_button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:widget.width?? Get.width*1,
      height: 48,
      decoration: const BoxDecoration(
          color: button2, borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Center(
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: textcolor,
              fontFamily: 'Sora',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class main_button1 extends StatefulWidget {
  final String buttonText;
  VoidCallback onPressed;
  main_button1({super.key, required this.buttonText,required this.onPressed});

  @override
  State<main_button1> createState() => _main_button1State();
}

class _main_button1State extends State<main_button1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: 311,
        height: 48,
        decoration: const BoxDecoration(
            color: button2,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
        child: Center(
          child: Text(
            widget.buttonText,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
                color: textcolor,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// class RoundButton extends StatelessWidget {
//   String title;
//   final VoidCallback onTap;
//   final bool loading;
//   double?width;
//   double?height;
//   RoundButton({
//     Key? key,
//     required this.title,
//     required this.onTap,
//     this.loading=false,
//     this.width,
//     this.height
//   }) : super(key: key);
//   // final _controller=Get.put(BackendController());
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height:height?? 6.h,
//         width:width?? Get.width*1,
//         decoration: BoxDecoration(
//
//             color: primaryColor,
//
//             borderRadius: BorderRadius.circular(4)
//         ),
//         child: Center(
//             child: Obx(() => _controller.loading.value?const SpinKitFadingCircle(color: Colors.white,size: 20,)
//                 :Text(title,style: const TextStyle(    color: textcolor,
//                 fontFamily: 'Sora',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600),),)
//         ),
//
//       ),
//     );
//   }
// }