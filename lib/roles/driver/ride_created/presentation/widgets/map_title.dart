import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget getMapTitle(BuildContext context, String title) {
  return Container(
      height: getDynamicHeight(context, 6),
      width: getDynamicWidth(context, 87),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.black),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CustomText(
          text: title,
          fontSize: 32,
          textAlign: TextAlign.center,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ));
}
