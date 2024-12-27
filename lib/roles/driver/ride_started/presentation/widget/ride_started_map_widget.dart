import 'dart:async';
import 'dart:math';
import 'package:ezyride_frontend/roles/driver/google_map/presentation/map_widget.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/ride_created_map_provider.dart';
import 'package:ezyride_frontend/roles/driver/ride_started/business/ride_started_get_route.dart';
import 'package:ezyride_frontend/roles/driver/ride_started/data/ride_started_map_repo.dart';
import 'package:ezyride_frontend/roles/driver/ride_started/presentation/widget/build_nav_inst.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RideStartedMapPage extends StatefulWidget {
  final LatLng initialPosition;
  final Map<String?, LocationData?> dropOffLocations;

  const RideStartedMapPage({
    super.key,
    required this.initialPosition,
    required this.dropOffLocations,
  });

  @override
  State<RideStartedMapPage> createState() => _RideStartedMapPageState();
}

class _RideStartedMapPageState extends State<RideStartedMapPage> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late RideStartedGetRoute _getRoute;
  late Location _location;
  late StreamSubscription<LocationData> _locationSubscription;

  List<Map<String, dynamic>>? _routeSteps;
  int _currentStepIndex = 0;
  String _currentInstruction = "Starting navigation...";
  LatLng? _currentPosition;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _location = Location();
    final repository = RideStartedDirectionsRepository(client: http.Client());
    _getRoute = RideStartedGetRoute(repository: repository);

    _location.requestPermission().then((permissionGranted) {
      if (permissionGranted == PermissionStatus.granted) {
        _locationSubscription =
            _location.onLocationChanged.listen((locationData) {
          setState(() {
            _currentPosition =
                LatLng(locationData.latitude!, locationData.longitude!);
            _updateDriverMarker();
            _updatePolyline();
            _checkStepCompletion();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    Provider.of<RideCreatedMapProvider>(context, listen: false)
        .removeListener(_onIdChanged);
    super.dispose();
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

      final steps = await _getRoute.execute(
        id ?? location.toString(),
        widget.initialPosition,
        locationLatLng,
        mapProvider,
      );
      _routeSteps = steps;
      _currentInstruction = _routeSteps![0]['instruction'];
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

  void _updateDriverMarker() {
    if (_currentPosition != null) {
      _markers.removeWhere((marker) => marker.markerId.value == 'driver');
      _addMarker(
        'driver',
        _currentPosition!,
        'Your Location',
        BitmapDescriptor.hueBlue,
      );
    }
  }

  void _updatePolyline() {
    if (_currentPosition != null && _routeSteps != null) {
      final routePoints = [_currentPosition!];
      for (var step in _routeSteps!) {
        routePoints.add(step['end_location']);
      }
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: routePoints,
          color: Colors.blue,
          width: 5,
        ),
      );
    }
  }

  void _checkStepCompletion() {
    if (_routeSteps == null || _currentStepIndex >= _routeSteps!.length) return;

    final nextStep = _routeSteps![_currentStepIndex];
    final nextStepPosition = nextStep['end_location'] as LatLng;

    final distanceToNextStep = _calculateDistance(
      _currentPosition!,
      nextStepPosition,
    );

    if (distanceToNextStep < 20) { // If within 20 meters of the step's endpoint
      setState(() {
        _currentStepIndex++;
        if (_currentStepIndex < _routeSteps!.length) {
          _currentInstruction = _routeSteps![_currentStepIndex]['instruction'];
        } else {
          _currentInstruction = "You have reached your destination.";
        }
      });
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371000; // Radius in meters
    final dLat = (end.latitude - start.latitude) * (pi / 180);
    final dLng = (end.longitude - start.longitude) * (pi / 180);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(start.latitude * (pi / 180)) *
            cos(end.latitude * (pi / 180)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
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
    return Stack(
      children: [
        MapWidget(
          markers: _markers,
          myLocationButtonEnabled: false,
          polylines: _polylines,
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition,
            zoom: 20,
          ),
          onMapCreated: (controller) => _controller = controller,
        ),
        buildNavigationInstructions(
            _routeSteps, _currentStepIndex, context),
      ],
    );
  }
}
