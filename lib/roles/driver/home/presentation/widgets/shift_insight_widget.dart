import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget getShiftInsights(BuildContext context) {
  return Positioned(
    left: getDynamicWidth(context, 10),
    right: getDynamicWidth(context, 10),
    bottom: getDynamicHeight(context, 50),
    child: Container(
      padding: EdgeInsets.all(getDynamicWidth(context, 5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Curved edges
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          CustomText(
            text: "Shift Insights",
            fontSize: getDynamicHeight(context, 3),
            textAlign: TextAlign.center,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          // Divider
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: getDynamicHeight(context, 1.5),
            ),
            child: const Divider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
          // Shift Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInfoRow(
                context,
                "Total Shift Hours:",
                "12 hrs", // Example value
              ),
              SizedBox(height: getDynamicHeight(context, 1)),
              buildInfoRow(
                context,
                "Total Rides Taken:",
                "24 rides", // Example value
              ),
              SizedBox(height: getDynamicHeight(context, 1)),
              buildInfoRow(
                context,
                "Total Money Earned:",
                "\$450", // Example value
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Helper method to create rows of information
Widget buildInfoRow(BuildContext context, String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: label,
        fontSize: getDynamicHeight(context, 2),
        color: Colors.black,
        fontWeight: FontWeight.w600, textAlign: TextAlign.center,
      ),
      CustomText(
        text: value,
        fontSize: getDynamicHeight(context, 2),
        color: Colors.black87,
        fontWeight: FontWeight.w400, textAlign: TextAlign.center,
      ),
    ],
  );
}
