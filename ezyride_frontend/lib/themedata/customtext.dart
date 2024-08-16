import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final Color color;
  final FontWeight fontWeight; // Added fontWeight parameter

  const CustomText({
    super.key,
    required this.text,
    this.fontFamily = "Inter",
    required this.fontSize,
    required this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    required this.color,
    this.fontWeight = FontWeight.normal, // Default fontWeight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: color,
        fontWeight: fontWeight, // Use fontWeight in TextStyle
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
