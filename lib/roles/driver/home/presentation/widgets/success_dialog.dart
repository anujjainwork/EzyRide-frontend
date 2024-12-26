import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          height: getDynamicHeight(context, 20),
          width: getDynamicWidth(context, 80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: CustomText(
                  text: "Shift ended successfully",
                  fontSize: 24,
                  textAlign: TextAlign.center,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 15),
              Icon(
                Icons.check_circle,
                color: Colors.green, // Customize the color as needed
                size: 80,
              ),
            ],
          ),
        ),
      );
    },
  );
}