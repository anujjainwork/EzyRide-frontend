import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final String id;
  final List<LatLng> points;

  RouteModel({required this.id, required this.points});
}
