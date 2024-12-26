import 'dart:convert';
import 'package:ezyride_frontend/roles/driver/google_map/constants/map_constants.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/ride_created_map_provider.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DirectionsRepository {
  final http.Client client;
  DirectionsRepository({required this.client});

  Future<List<LatLng>> fetchRoute(String id,LatLng origin, LatLng destination, RideCreatedMapProvider rideCreatedMapProvider) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${Constants.googleApiKey}';
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final points = routes[0]['overview_polyline']['points'];
        final route = routes[0];
        final legs = route['legs'] as List;
        final duration = legs[0]['duration']['text'];
        final distance = legs[0]['distance']['text']; 
        rideCreatedMapProvider.addDistDurationList(id,distance,duration);
        return _decodePolyline(points);
      } else {
        throw Exception('No routes found');
      }
    } else {
      throw Exception('Failed to fetch directions: ${response.body}');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length, lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
