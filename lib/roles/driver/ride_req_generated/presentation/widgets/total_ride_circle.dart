import 'package:ezyride_frontend/common/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget totalRiderCircle(double screenHeight, double screenWidth, WebSocketProvider wbprovider) {
  return Container(
    width: screenHeight * 0.18, // Diameter of the circle
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.black, // Border color
        width: 2,
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: CircleAvatar(
      radius: screenHeight * 0.09,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: "${wbprovider.totalMembers}/4",
            fontSize: screenHeight * 0.07,
            textAlign: TextAlign.center,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                color: Colors.black,
                height: 1.2, // Line height to control spacing
              ),
              children: const [
                TextSpan(text: "Total no. of\n"),
                TextSpan(text: "members"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}