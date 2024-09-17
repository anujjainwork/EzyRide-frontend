// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:ezyride_frontend/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class CheckAvailProvider with ChangeNotifier {
  String? accessToken;
  String? serverUrl;
  WebSocketChannel? locationChannel;
  bool isLocationChannelInitialized = false;
  bool isConnectedLocation = false;
  dynamic _locationWsMessage;

  // Store the current location received from the WebSocket
  double? latitude;
  double? longitude;


  Future<void> init() async {
    try {
      // Get access token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('accessToken');
      print('AccessToken retrieved: $accessToken');

      // Initialize WebSocket connections if the token is available
      if (accessToken != null) {
        _initializeLocationWebSocket();
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
    serverUrl = await Config.serverUrl;
    try {
      print('Attempting to connect to Location WebSocket...');
      locationChannel = WebSocketChannel.connect(
        Uri.parse('$serverUrl/location?token=$accessToken'),
      );

      isLocationChannelInitialized = true;
      isConnectedLocation = true;

      print('Location WebSocket connection established.');

      locationChannel!.stream.listen(
        (message) {
          try {
            print('Message received from Location WebSocket: $message');
            final data = jsonDecode(message);
              _locationWsMessage = data;
              latitude = data["latitude"];
              longitude = data["longitude"];
              notifyListeners();
          } catch (e) {
            print('Error parsing Location WebSocket message: $e');
          }
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

  void _reconnectLocationWebSocket() {
    if (!isConnectedLocation) {
      Future.delayed(const Duration(seconds: 5), () {
        print('Reconnecting Location WebSocket...');
        _initializeLocationWebSocket();
      });
    }
  }

  @override
  void dispose() {
    locationChannel?.sink.close(status.goingAway);
    super.dispose();
  }
}
