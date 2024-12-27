import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget getRideButton(BuildContext context, Color color, String title, String approute) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: getDynamicWidth(context, 100),
        height: getDynamicHeight(context, 7),
        color: color,
          child: Center(
            child: CustomText(
              text: title,
              fontSize: 20,
              textAlign: TextAlign.center,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}
