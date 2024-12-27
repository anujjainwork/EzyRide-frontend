import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget locationWidget(BuildContext context) {
  return Opacity(
    opacity: 0.7,
    child: Container(
        height: getDynamicHeight(context, 6.5),
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
        padding:
            const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 10),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Pick Up Location",
                  fontSize: 18,
                  textAlign: TextAlign.center,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                CustomText(
                  text: "IIITN",
                  fontSize: 18,
                  textAlign: TextAlign.center,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(
              height: getDynamicHeight(context, 0.5),
            ),
          ],
        )),
  );
}
