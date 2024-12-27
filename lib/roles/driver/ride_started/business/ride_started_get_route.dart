import 'package:ezyride_frontend/roles/driver/ride_started/data/ride_started_map_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideStartedGetRoute {
  final RideStartedDirectionsRepository repository;

  RideStartedGetRoute({required this.repository});

  Future<List<Map<String, dynamic>>> execute(
      String id, LatLng origin, LatLng destination, dynamic mapProvider) async {
    return await repository.getDirections(origin, destination);
  }
}
