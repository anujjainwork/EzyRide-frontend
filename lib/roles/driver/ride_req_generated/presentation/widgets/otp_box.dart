import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget otpBox(double screenHeight, double screenWidth, String? otp) {
  return Container(
    height: screenHeight * 0.1,
    width: screenWidth * 0.85,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: CustomText(
        text: otp != null ? "Ride OTP: $otp" : "Fetching OTP...",
        fontSize: 24,
        textAlign: TextAlign.center,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
