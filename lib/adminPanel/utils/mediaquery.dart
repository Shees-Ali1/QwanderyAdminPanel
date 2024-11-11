import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext{

  MediaQueryData get mediaQuery=>MediaQuery.of(this);

  double get screenWidth=>mediaQuery.size.width;
  double get screenHeight=>mediaQuery.size.height;
}
double webWidth=600.0;




const primaryColoradmin=Color(0xffAE9C7F);
const adminblack = Color(0x66000000);
const primaryColor=Color(0xffAE9C7F);
const whiteColor=Colors.white;
const blackColor=Colors.black;
const greenColor=Colors.green;
const redColor=Colors.red;
final bgColor=Colors.grey;