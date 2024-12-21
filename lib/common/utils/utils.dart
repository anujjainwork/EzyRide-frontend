import 'package:flutter/material.dart';

double getDynamicHeight(BuildContext context, double percentage) {
  double screenHeight = MediaQuery.of(context).size.height;
  double height = screenHeight * percentage / 100;
  return height;
}

double getDynamicWidth(BuildContext context, double percentage) {
  double screenWidth = MediaQuery.of(context).size.width;
  double width = screenWidth * percentage / 100;
  return width;
}
