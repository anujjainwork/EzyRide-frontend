import 'package:flutter/material.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: title,
        fontSize: 22,
        textAlign: TextAlign.center,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}