import 'package:flutter/material.dart';

const splashcolor1 = Color(0xffF8F8F8);
const splashcolor2 = Color(0xffFFE4E9);
const splashcolor3 = Color(0xffE1FFED);

const customcolor = Color(0xff191D21);
const customcolor1 = Color(0xff656F77);

const button1 = Color(0xffF8F8F8);
const button2 = Color(0xffAE9C7F);

const textcolor = Color(0xffFFFFFF);

TextStyle customSplashtext() {
  return const TextStyle(
    fontFamily: 'Sora',
    fontSize: 36,
    color: customcolor,
    fontWeight: FontWeight.w700,
  );
}

TextStyle customSplashtext1() {
  return const TextStyle(
      fontFamily: 'Crimson Text',
      fontSize: 18,
      color: Color.fromRGBO(101, 111, 119, 1),
      fontWeight: FontWeight.w400);
}

TextStyle customText() {
  return const TextStyle(
      color: Color(0xff222222),
      fontFamily: 'Sora',
      fontSize: 24,
      fontWeight: FontWeight.w700);
}

TextStyle customText1() {
  return const TextStyle(
      color: Color.fromRGBO(101, 111, 119, 1),
      fontFamily: 'Crimson Text',
      fontSize: 14.5,
      fontWeight: FontWeight.w400);
}
