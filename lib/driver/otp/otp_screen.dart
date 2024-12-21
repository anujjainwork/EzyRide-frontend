// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/driver/ride_created/create_ride_screen.dart';
import 'package:ezyride_frontend/driver/start_ride/start_ride_screen.dart';
import 'package:ezyride_frontend/driver/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class DriverOtp extends StatefulWidget {
  const DriverOtp({super.key});

  @override
  State<DriverOtp> createState() => _DriverOtpState();
}

class _DriverOtpState extends State<DriverOtp> {
  String? otp;
  String? accessToken;
  String? serverUrl;
  WebSocketChannel? rideChannel;
  bool isRideChannelInitialized = false;
  bool isConnectedRide = false;
  bool isRideRequested = false;

  @override
  void initState() {
    super.initState();
    _getOtp();
    // Initialise WebSocketProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebSocketProvider>(context, listen: false).init();
      // Listen to changes in WebSocketProvider
      Provider.of<WebSocketProvider>(context, listen: false)
          .addListener(_onWebSocketMessage);
    });
  }

  @override
  void dispose() {
    // Remove listener when the widget is disposed
    Provider.of<WebSocketProvider>(context, listen: false)
        .removeListener(_onWebSocketMessage);
    super.dispose();
  }

  void _onWebSocketMessage() {
    if (Provider.of<WebSocketProvider>(context, listen: false)
        .isRideRequested) {
      setState(() {
        isRideRequested = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WebSocketProvider webSocketProvider =
        Provider.of<WebSocketProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFCDE9FF), Color(0xFFD9E7F1), Color(0xFFE4E4E4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  'lib/assets/images/autorickshaw.svg',
                  width: screenWidth,
                  fit: BoxFit.contain,
                  semanticsLabel: 'A description of the SVG image',
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _totalRiderCircle(
                        screenHeight, screenWidth, webSocketProvider),
                    const SizedBox(height: 30),
                    _otpBox(screenHeight, screenWidth),
                    const SizedBox(height: 20),
                    _rideButton(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      text: "Generate another OTP",
                      textsize: 20,
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.85,
                      borderColor: Colors.black,
                      onPressed: isRideRequested
                          ? () {
                              Provider.of<WebSocketProvider>(context,
                                      listen: false)
                                  .confirmRide();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DriverStartRide(
                                            dropOffLocationName:
                                                webSocketProvider
                                                    .dropOffLocationName!,
                                            dropOffLocationData:
                                                webSocketProvider
                                                    .dropOffLocationData!,
                                          )));
                            }
                          : null,
                      isEnabled: isRideRequested,
                      boxcolor: Colors.black,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _rideButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          text: "Confirm Ride",
                          textsize: 16,
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.40,
                          borderColor: Colors.green,
                          onPressed: isRideRequested
                              ? () {
                                  Provider.of<WebSocketProvider>(context,
                                          listen: false)
                                      .confirmRide();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DriverStartRide(
                                                dropOffLocationName:
                                                    webSocketProvider
                                                        .dropOffLocationName!,
                                                dropOffLocationData:
                                                    webSocketProvider
                                                        .dropOffLocationData!,
                                              )));
                                }
                              : null,
                          isEnabled: isRideRequested,
                          boxcolor: Colors.white,
                          textColor: Colors.green,
                        ),
                        _rideButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          text: "Cancel Ride",
                          textsize: 16,
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.40,
                          borderColor: Colors.red,
                          onPressed: isRideRequested
                              ? () {
                                  Provider.of<WebSocketProvider>(context,
                                          listen: false)
                                      .declineRide();
                                  Navigator.pop(context);
                                }
                              : null,
                          isEnabled: isRideRequested,
                          boxcolor: Colors.white,
                          textColor: Colors.red,
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 280)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rideButton(
      {required double screenHeight,
      required double screenWidth,
      required String text,
      required VoidCallback? onPressed,
      required bool isEnabled,
      required double textsize,
      required Color boxcolor,
      required Color borderColor,
      required Color textColor,
      required double height,
      required double width}) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.2,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxcolor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CustomText(
            text: text,
            fontSize: textsize,
            textAlign: TextAlign.center,
            color: textColor,
          ),
        ),
      ),
    );
  }

 Widget _generateOtpButton(
      {required double screenHeight,
      required double screenWidth,
      required String text,
      required VoidCallback? onPressed,
      required bool isEnabled,
      required double textsize,
      required Color boxcolor,
      required Color borderColor,
      required Color textColor,
      required double height,
      required double width,
      required WebSocketProvider wbprovider}) {
    return Opacity(
      opacity: !(wbprovider.isFull) ? 1.0 : 0.2,
      child: InkWell(
        onTap: !(wbprovider.isFull) ? onPressed : null,
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxcolor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CustomText(
            text: text,
            fontSize: textsize,
            textAlign: TextAlign.center,
            color: textColor,
          ),
        ),
      ),
    );
  }

Widget _totalRiderCircle(double screenHeight, double screenWidth, WebSocketProvider wbprovider) {
  return Container(
    width: screenHeight * 0.18, // Diameter of the circle
    height: screenHeight * 0.18,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.black, // Border color
        width: 2,
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: CircleAvatar(
      radius: screenHeight * 0.09,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: "${wbprovider.totalRiders}/4",
            fontSize: screenHeight * 0.07,
            textAlign: TextAlign.center,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                color: Colors.black,
                height: 1.2, // Line height to control spacing
              ),
              children: const [
                TextSpan(text: "Total no. of\n"),
                TextSpan(text: "riders"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _otpBox(double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: CustomText(
          text: "Ride otp: $otp",
          fontSize: 24,
          textAlign: TextAlign.center,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _getOtp() async {
    const String baseUrl = Config.baseUrl;
    const String url = "$baseUrl/requestride/getotp";
    final prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString('accessToken');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["respCode"] == 200) {
          final String receivedOtp = responseBody['respBody'];
          if (receivedOtp != null) {
            setState(() {
              otp = receivedOtp;
            });
          }
        } else {
          throw Exception(
              "Response code is not 200 -> ${responseBody["respCode"]}");
        }
      } else {
        throw Exception(
            "Response status code not 200 -> ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception(e);
    }
  }
}
