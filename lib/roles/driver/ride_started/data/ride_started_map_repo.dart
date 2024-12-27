import 'dart:convert';
import 'package:ezyride_frontend/roles/driver/google_map/constants/map_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RideStartedDirectionsRepository {
  final http.Client client;

  RideStartedDirectionsRepository({required this.client});

  Future<List<Map<String, dynamic>>> getDirections(
      LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?'
      'origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&key=${Constants.googleApiKey}',
    );

    final response = await client.get(url);

 if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final steps = data['routes'][0]['legs'][0]['steps'] as List;
      return steps.map((step) {
        return {
          'instruction': _stripHtmlTags(step['html_instructions']),
          'distance': step['distance']['text'],
          'maneuver': step['maneuver'] ?? 'straight',
          'end_location': LatLng(
            step['end_location']['lat'],
            step['end_location']['lng'],
          ),
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch directions');
    }
  }
    String _stripHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(regex, '');
  }
}
