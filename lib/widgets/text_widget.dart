import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color? textColor;
  final TextAlign? textAlign; // Correctly define the textAlign parameter

  const CustomText({
    Key? key,
    required this.text,
    required this.fontWeight,
    required this.fontSize,
    this.textColor,
    this.textAlign, // Add a comma here
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center, // Use textAlign from the constructor, default to center
      style: GoogleFonts.jost(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: textColor ?? Colors.white,
      ),
    );
  }
}
