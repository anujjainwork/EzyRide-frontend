import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget getRideButton(BuildContext context) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: getDynamicWidth(context, 100),
        height: getDynamicHeight(context, 7),
        color: Colors.green,
        child: GestureDetector(
          child: const Center(
            child: CustomText(
              text: "Start Ride",
              fontSize: 20,
              textAlign: TextAlign.center,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ));
}
