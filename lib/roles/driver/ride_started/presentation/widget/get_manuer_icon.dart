import 'package:flutter/material.dart';

IconData getManeuverIcon(String maneuver) {
  switch (maneuver) {
    case 'turn-left':
      return Icons.turn_left;
    case 'turn-right':
      return Icons.turn_right;
    case 'uturn-left':
    case 'uturn-right':
      return Icons.u_turn_left;
    case 'straight':
    default:
      return Icons.arrow_upward;
  }
}
