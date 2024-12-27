import 'package:flutter/material.dart';

Widget getUpDownWidget(bool showRiders) {
  return Container(
    height: 30,
    width: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white.withOpacity(0.5),
    ),
    child: Center(
        child: showRiders
            ? const Icon(
                Icons.arrow_downward_outlined,
                color: Colors.black,
              )
            : const Icon(
                Icons.arrow_upward_outlined,
                color: Colors.black,
              )),
  );
}
