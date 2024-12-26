import 'package:ezyride_frontend/roles/driver/google_map/data/direction_repo.dart';
import 'package:ezyride_frontend/roles/driver/google_map/domain/get_route.dart';
import 'package:ezyride_frontend/roles/driver/google_map/presentation/map_widget.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/ride_created_map_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  final LatLng initialPosition;
  final Map<String?, LocationData?> dropOffLocations;

  const MapPage({
    super.key,
    required this.initialPosition,
    required this.dropOffLocations,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late GetRoute _getRoute;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final repository = DirectionsRepository(client: http.Client());
    _getRoute = GetRoute(repository: repository);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final mapProvider =
          Provider.of<RideCreatedMapProvider>(context, listen: false);
      _initializeMarkersAndRoutes(mapProvider);
      _isInitialized = true;
    }
    Provider.of<RideCreatedMapProvider>(context).addListener(_onIdChanged);
  }

  Future<void> _initializeMarkersAndRoutes(
      RideCreatedMapProvider mapProvider) async {
    _addMarker('initial', widget.initialPosition, 'Initial Position',
        BitmapDescriptor.hueRed);

    for (var entry in widget.dropOffLocations.entries) {
      final id = entry.key;
      final location = entry.value;
      final LatLng locationLatLng =
          LatLng(location!.latitude!, location.longitude!);

      _addMarker(id ?? location.toString(), locationLatLng, id ?? 'Drop-off',
          BitmapDescriptor.hueBlue);

      final route = await _getRoute.execute(id ?? location.toString(),
          widget.initialPosition, locationLatLng, mapProvider);
      _addPolyline(id ?? location.toString(), route);
    }

    setState(() {});
  }

  void _addMarker(String id, LatLng position, String title, double hue) {
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      ),
    );
  }

  void _addPolyline(String id, List<LatLng> points) {
    _polylines.add(
      Polyline(
        polylineId: PolylineId(id),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  void _onIdChanged() {
    final mapProvider =
        Provider.of<RideCreatedMapProvider>(context, listen: false);
    final selectedKey =
        mapProvider.id ?? widget.dropOffLocations.entries.first.key;
    if (selectedKey != null) {
      final selectedMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == selectedKey,
        orElse: () => _markers.first,
      );
      _controller.animateCamera(
        CameraUpdate.newLatLngZoom(selectedMarker.position, 14.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      markers: _markers,
      myLocationButtonEnabled: false,
      polylines: _polylines,
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: 10,
      ),
      onMapCreated: (controller) => _controller = controller,
    );
  }
}
