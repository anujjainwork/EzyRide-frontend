import 'package:ezyride_frontend/roles/driver/google_map/data/direction_repo.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/ride_created_map_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetRoute {
  final DirectionsRepository repository;

  GetRoute({required this.repository});

  Future<List<LatLng>> execute(String id,LatLng origin, LatLng destination, RideCreatedMapProvider mapProvider) {
    return repository.fetchRoute(id,origin, destination,mapProvider);
  }
}
