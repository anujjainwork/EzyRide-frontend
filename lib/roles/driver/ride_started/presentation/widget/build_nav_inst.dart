import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/roles/driver/ride_started/presentation/widget/get_manuer_icon.dart';
import 'package:flutter/material.dart';

Widget buildNavigationInstructions(List<Map<String, dynamic>>? _routeSteps, int _currentStepIndex, BuildContext context) {
  if (_routeSteps == null || _currentStepIndex >= _routeSteps.length) {
    return Positioned(
      bottom: getDynamicHeight(context, 15),
      left: getDynamicWidth(context, 5),
      right: getDynamicWidth(context, 5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: const CustomText(
          text: "You have reached your destination.",
          fontSize: 15,
          textAlign: TextAlign.center,
          color: Colors.black,
        ),
      ),
    );
  }

  final currentStep = _routeSteps![_currentStepIndex];
  final instruction = currentStep['instruction'];
  final distance = currentStep['distance'];
  final maneuver = currentStep['maneuver'];

  return Positioned(
      bottom: getDynamicHeight(context, 9),
      left: getDynamicWidth(context, 5),
      right: getDynamicWidth(context, 5),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border:Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(getManeuverIcon(maneuver), size: 32, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:  instruction,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: Colors.black,
                ),
                CustomText(
                  text:  distance,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
