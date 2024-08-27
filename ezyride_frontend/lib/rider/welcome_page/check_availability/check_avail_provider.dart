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
  WebSocketChannel? channel;
  bool isWebSocketInitialized = false;
  bool isConnected = false;

  // Store the current location received from the WebSocket
  double? latitude;
  double? longitude;

  Future<void> init() async {
    try {
      // Get access token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('accessToken');
      print('AccessToken retrieved: $accessToken');

      // Initialize the WebSocket connection if the token is available
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

      channel!.stream.listen(
              (message) {
                try {
                  print('Message received from server: $message');
                  final data = jsonDecode(message);
                  latitude = data['latitude'] as double?;
                  longitude = data['longitude'] as double?;
                  notifyListeners();
                } catch (e) {
                  print('Error parsing WebSocket message: $e');
                }
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

  @override
  void dispose() {
    channel?.sink.close(status.goingAway);
    super.dispose();
  }
}
