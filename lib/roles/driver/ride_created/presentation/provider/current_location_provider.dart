import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationProvider extends ChangeNotifier {
  LatLng? _currentLocation;

  LatLng? get currentLocation => _currentLocation;

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
  }

  Future<void> getDriverCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching current location: $e");
    }
  }
}
