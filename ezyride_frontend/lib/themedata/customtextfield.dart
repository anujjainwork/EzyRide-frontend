import 'package:flutter/material.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final double screenHeight;
  final double screenWidth;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    required this.screenHeight,
    required this.screenWidth,
    this.inputFormatters
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Colors.black,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 6.0),
        Container(
          width: screenWidth * 0.8,
          height: screenHeight *0.05,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
