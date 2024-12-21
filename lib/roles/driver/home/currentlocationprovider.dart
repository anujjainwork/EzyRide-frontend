// ignore_for_file: avoid_print

import 'dart:async';
import 'package:ezyride_frontend/config.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class LocationProvider with ChangeNotifier {
  String? accessToken;
  Location location = Location();
  Timer? _timer;
  WebSocketChannel? channel;
  bool isWebSocketInitialized = false;
  bool isConnected = false;
  String? serverUrl;

  LocationProvider();

  Future<void> init() async {
    try { 
      // Get access token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('accessToken');
      print('AccessToken retrieved: $accessToken');

      // Ensure location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print('Location service is disabled. Cannot proceed.');

          return;
        }
      }

      // Ensure location permissions are granted
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location permission denied. Cannot proceed.');
          return;
        }
      }
      print("Location permission granted: $permissionGranted");

      // Initialize the WebSocket connection if permission is granted
      if (accessToken != null) {
        _initializeWebSocket();
      } else {
        print('No access token found.');
      }
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  void _initializeWebSocket() async {

    serverUrl = Config.serverUrl;

    try {
      print('Attempting to connect to WebSocket...');
      channel = WebSocketChannel.connect(
        Uri.parse('$serverUrl/location?token=$accessToken'),
      );

      isWebSocketInitialized = true;
      isConnected = true;

      print('WebSocket connection established.');
      startLocationUpdates();

      // Listen for incoming messages or connection status
      channel!.stream.listen(
        (message) {
          print('Message received from server: $message');
        },
        onError: (error) {
          print('WebSocket error: $error');
          isConnected = false;
          _reconnectWebSocket();
        },
        onDone: () {
          print('WebSocket connection closed.');
          isConnected = false;
          _reconnectWebSocket();
        },
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
    }
  }

  void _reconnectWebSocket() {
    // Implement a reconnect strategy if needed
    if (isConnected == false) {
      Future.delayed(const Duration(seconds: 5), () {
        print('Reconnecting WebSocket...');
        _initializeWebSocket();
      });
    }
  }

  void startLocationUpdates() {
    // print('Starting location updates...');
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        // print('Requesting location...');
        LocationData locationData = await location.getLocation();
        // print('Location data retrieved: ${locationData.latitude}, ${locationData.longitude}');
        if (isWebSocketInitialized && channel != null && isConnected) {
          _sendLocationToWebSocket(locationData);
        }
      } catch (e) {
        print('Error getting location: $e');
      }
    });
  }

  void _sendLocationToWebSocket(LocationData locationData) {
    try {
      if (channel != null && isConnected) {
        final locationMessage = jsonEncode({
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        });

        // Send location data through WebSocket
        channel!.sink.add(locationMessage);
        // print('Location sent: $locationMessage');
      }
    } catch (e) {
      print('Failed to send location data: $e');
    }
  }

  void stopLocationUpdates() {
    _timer?.cancel();
    if (isWebSocketInitialized && channel != null) {
      channel!.sink.close();
      print('WebSocket connection closed.');
    }
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
}
