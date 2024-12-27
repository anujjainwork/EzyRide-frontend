import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final CameraPosition initialCameraPosition;
  final Function(GoogleMapController) onMapCreated;
  final bool myLocationButtonEnabled;

  const MapWidget({
    super.key,
    required this.markers,
    required this.polylines,
    required this.initialCameraPosition,
    required this.onMapCreated, required this.myLocationButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      scrollGesturesEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled:true,
      initialCameraPosition: initialCameraPosition,
      myLocationButtonEnabled: myLocationButtonEnabled,
      markers: markers,
      polylines: polylines,
      onMapCreated: onMapCreated,
    );
  }
}
