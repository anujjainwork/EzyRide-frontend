// widgets/background_gradient.dart
import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Gradient gradient;
  const BackgroundGradient({required this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
    );
  }
}