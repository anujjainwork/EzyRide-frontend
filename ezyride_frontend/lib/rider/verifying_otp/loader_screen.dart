import 'dart:convert';

import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/rider/ride_started/rider_start_screen.dart';
import 'package:ezyride_frontend/rider/verifying_otp/Loader.dart';
import 'package:ezyride_frontend/rider/welcome_page/start_riding/enter_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoaderScreen extends StatefulWidget {
  final List<double> dropLocationCoordinates;
  final String dropLocation;
  final int riderId;
  final String username;
  final String otp;
  final String totalMembers;

  const LoaderScreen({
    super.key,
    required this.dropLocationCoordinates,
    required this.dropLocation,
    required this.riderId,
    required this.username,
    required this.otp,
    required this.totalMembers
  });

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  String? accessToken;
  
  @override
  void initState(){
    super.initState();
    _verifyOtp(widget.otp);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xFFCDE9FF), Color(0xFFD9E7F1), Color(0xFFE4E4E4)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: const Center(
          child: Loader(
        size: 150,
      )),
    )));
  }

  Future<void> _verifyOtp(String otp) async {
    const String baseUrl = Config.baseUrl;
    String url = "$baseUrl/requestride/verifyotp?otp=$otp";
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');

    try {
      // Get the current location of the device
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "pickUpLocation": [position.longitude, position.latitude],
          "dropOffLocation": widget.dropLocationCoordinates,
          "dropOffLocationName":widget.dropLocation,
          "totalMembers":widget.totalMembers,
          "requestedTime": DateTime.now().toIso8601String(),
          "rider": {"id": widget.riderId, "name": widget.username},
          "paymentMethod": "UPI",
          "rideRequestStatus": "PENDING"
        }),
      );

      print('otp api called');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["respCode"] == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
          RiderRideStarted(
            dropLocationCoordinates: widget.dropLocationCoordinates,
            dropLocation: widget.dropLocation,
          )));
        }
        if(responseBody["resp_code"]==201){
          _showErrorDialog(responseBody["respMsg"]);
        }
         else {
          _showErrorDialog(responseBody["respMsg"]);
        }
      } else {
        _showErrorDialog("Failed to request ride. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EnterLocation()));
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

}

