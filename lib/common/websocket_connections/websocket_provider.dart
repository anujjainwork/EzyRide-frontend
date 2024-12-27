// ignore_for_file: avoid_print

import 'dart:async';
import 'package:ezyride_frontend/config.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketProvider with ChangeNotifier {
  String? accessToken;
  Location location = Location();
  Timer? _timer;
  LocationData? locationData;
  LocationData? dropOffLocationData;
  String? dropOffLocationName;
  Map<String?,LocationData?> dropOffLocationsList = {};
  String? riderName;
  List<String> riderNames = [];
  int totalRiders = 0;
  int totalReqMembers = 0;
  int totalMembers = 0;
  bool isFull = false;

  WebSocketChannel? locationChannel;
  WebSocketChannel? rideChannel;

  bool isLocationChannelInitialized = false;
  bool isRideChannelInitialized = false;

  bool isConnectedLocation = false;
  bool isConnectedRide = false;
  bool isRideRequested = false;

  String? serverUrl;

  WebSocketProvider();

  Future<bool> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return false;
      }
    }

    // Check if location permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permission denied.');
        return false;
      }
    }

    // Handle "permanently denied" state
    if (permissionGranted == PermissionStatus.deniedForever) {
      print('Location permission permanently denied.');
      // Show a dialog to guide the user to enable permissions
      return false;
    }

    print('Location permission granted.');
    return true;
  }

  void checkIfFull() {
    if (totalReqMembers + totalMembers == 4) {
      isFull = true;
      notifyListeners();
    }
  }
  void setTotalMembers(){
    totalMembers += totalReqMembers;
    notifyListeners();
  }
  void addRiderToRiderList(){
    riderNames.add(riderName!);
    notifyListeners();
  }

  Future<void> init() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('accessToken');
      print('AccessToken retrieved: $accessToken');

      if (accessToken != null) {
        final isPermissionGranted = await _checkAndRequestLocationPermission();
        if (isPermissionGranted) {
          _initializeLocationWebSocket();
          _initializeRideWebSocket();
        } else {
          print('Cannot initialize WebSockets without location permission.');
        }
      } else {
        print('No access token found.');
      }
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  void _initializeLocationWebSocket() async {
    if (isLocationChannelInitialized) {
      print('Location WebSocket is already initialized.');
      return;
    }

    serverUrl = Config.serverUrl;
    try {
      print('Attempting to connect to Location WebSocket...');
      locationChannel = WebSocketChannel.connect(
        Uri.parse('$serverUrl/location?token=$accessToken'),
      );

      final locationBroadcastStream =
          locationChannel!.stream.asBroadcastStream();

      isLocationChannelInitialized = true;
      isConnectedLocation = true;

      print('Location WebSocket connection established.');
      startLocationUpdates();

      locationBroadcastStream.listen(
        (message) {
          print('Message received from Location WebSocket: $message');
          // Handle location WebSocket messages here
        },
        onError: (error) {
          print('Location WebSocket error: $error');
          isConnectedLocation = false;
          _reconnectLocationWebSocket();
        },
        onDone: () {
          print('Location WebSocket connection closed.');
          isConnectedLocation = false;
          _reconnectLocationWebSocket();
        },
      );
    } catch (e) {
      print('Failed to connect to Location WebSocket: $e');
    }
  }

  void _initializeRideWebSocket() async {
    if (isRideChannelInitialized) {
      print('Ride WebSocket is already initialized.');
      return;
    }

    serverUrl = Config.serverUrl;
    try {
      print('Attempting to connect to Ride WebSocket...');
      rideChannel = WebSocketChannel.connect(
        Uri.parse('$serverUrl/ride-request?token=$accessToken'),
      );

      final rideBroadcastStream = rideChannel!.stream.asBroadcastStream();

      isRideChannelInitialized = true;
      isConnectedRide = true;

      print('Ride WebSocket connection established.');

      rideBroadcastStream.listen(
        (message) {
          final decodedMessage = jsonDecode(message);

          if (decodedMessage['messageType'] == "RIDE_REQUESTED") {
            isRideRequested = true;
            final rideRequestData = decodedMessage['rideRequestData'];

            print("Incoming ride message $message");
            if (rideRequestData != null) {
              final dropOffLocationCords = rideRequestData['dropOffLocation'];

              Map<String, dynamic> locationMap = {
                'latitude': dropOffLocationCords![1],
                'longitude': dropOffLocationCords![0],
              };

              dropOffLocationData = LocationData.fromMap(locationMap);

              dropOffLocationName = rideRequestData['dropOffLocationName'];
              dropOffLocationsList.putIfAbsent(dropOffLocationName, () => dropOffLocationData);
              riderName = rideRequestData['rider']['user']['name'];
              totalReqMembers = rideRequestData['totalMembers'];
              notifyListeners();
            }
          }
          print('Message received from Ride WebSocket: $message');
        },
        onError: (error) {
          print('Ride WebSocket error: $error');
          if (error is WebSocketChannelException) {
            print('WebSocketChannelException: ${error.message}');
          }
          isConnectedRide = false;
          _reconnectRideWebSocket();
        },
        onDone: () {
          print('Ride WebSocket connection closed.');
          isConnectedRide = false;
          _reconnectRideWebSocket();
        },
      );
    } catch (e) {
      print('Failed to connect to Ride WebSocket: $e');
    }
  }

  void _reconnectLocationWebSocket() {
    if (!isConnectedLocation) {
      Future.delayed(const Duration(seconds: 5), () {
        print('Reconnecting Location WebSocket...');
        _initializeLocationWebSocket();
      });
    }
  }

  void _reconnectRideWebSocket() {
    if (!isConnectedRide) {
      Future.delayed(const Duration(seconds: 5), () {
        print('Reconnecting Ride WebSocket...');
        _initializeRideWebSocket();
      });
    }
  }

  void confirmRide() {
    try {
      if (rideChannel != null && isConnectedRide) {
        checkIfFull();
        riderNames.add(riderName!);
        totalMembers = totalReqMembers;
        const rideMessage = "RIDE_CONFIRMED";
        rideChannel!.sink.add(rideMessage);
        print('ride message sent: $rideMessage');
        notifyListeners();
      }
    } catch (e) {
      print('Failed to send location data: $e');
    }
  }

  void declineRide() {
    try {
      if (rideChannel != null && isConnectedRide) {
        const rideMessage = "RIDE_DECLINED";
        rideChannel!.sink.add(rideMessage);
        print('ride message sent: $rideMessage');
      }
    } catch (e) {
      print('Failed to send location data: $e');
    }
  }

  void startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        locationData = await location.getLocation();
        _sendLocationToWebSocket(locationData!);
      } catch (e) {
        print('Error getting location: $e');
      }
    });
  }

  void _sendLocationToWebSocket(LocationData locationData) {
    try {
      if (locationChannel != null && isConnectedLocation) {
        final locationMessage = jsonEncode({
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        });
        locationChannel!.sink.add(locationMessage);
        print('Location sent: $locationMessage');
      }
    } catch (e) {
      print('Failed to send location data: $e');
    }
  }

  void stopLocationUpdates() {
    _timer?.cancel();
    if (isLocationChannelInitialized && locationChannel != null) {
      locationChannel!.sink.close();
      print('Location WebSocket connection closed.');
    }
  }

  @override
  void dispose() {
    stopLocationUpdates();
    if (isRideChannelInitialized && rideChannel != null) {
      rideChannel!.sink.close();
      print('Ride WebSocket connection closed.');
    }
    super.dispose();
  }
}
