// ignore_for_file: avoid_print
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/provider/otp_provider.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/widgets/otp_box.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/widgets/ride_button.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/widgets/total_ride_circle.dart';
import 'package:ezyride_frontend/common/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DriverRideReqGenerated extends StatefulWidget {
  const DriverRideReqGenerated({super.key});

  @override
  State<DriverRideReqGenerated> createState() => _DriverRideReqGeneratedState();
}

class _DriverRideReqGeneratedState extends State<DriverRideReqGenerated> {
  WebSocketProvider? _webSocketProvider;
  bool isRideRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OtpProvider>(context, listen: false).getOtp();
      _webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
      _webSocketProvider?.init();
      _webSocketProvider?.addListener(_onWebSocketMessage);
    });
  }

  @override
  void dispose() {
    // Safely remove the listener using the cached reference
    _webSocketProvider?.removeListener(_onWebSocketMessage);
    super.dispose();
  }

  void _onWebSocketMessage() {
    if (_webSocketProvider?.isRideRequested ?? false) {
      setState(() {
        isRideRequested = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WebSocketProvider webSocketProvider =
        Provider.of<WebSocketProvider>(context);
    OtpProvider otpProvider = Provider.of<OtpProvider>(context);
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
                    totalRiderCircle(
                        screenHeight, screenWidth, webSocketProvider),
                    const SizedBox(height: 30),
                    Consumer<OtpProvider>(
                      builder: (context, otpProvider, child) {
                        return otpBox(
                            screenHeight, screenWidth, otpProvider.otp);
                      },
                    ),
                    const SizedBox(height: 20),
                    rideButton(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      text: "Generate another OTP",
                      textsize: 20,
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.85,
                      borderColor: Colors.black,
                      onPressed: (webSocketProvider.totalMembers < 4)
                          ? () {
                              setState(() {
                                webSocketProvider.setTotalMembers();
                                webSocketProvider.addRiderToRiderList();
                                otpProvider.getOtp();
                              });
                            }
                          : null,
                      isEnabled: (webSocketProvider.totalMembers < 4) &&
                          isRideRequested,
                      boxcolor: Colors.black,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        rideButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          text: "Confirm Ride",
                          textsize: 16,
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.40,
                          borderColor: Colors.green,
                          onPressed: isRideRequested
                              ? () {
                                // print('dropOffLocationList ${webSocketProvider.dropOffLocationsList[]}');
                                  _webSocketProvider?.confirmRide();
                                  Navigator.pushReplacementNamed(
                                      context, AppRouteNames.driverRideCreated,
                                      arguments: {
                                        'dropOffLocationsList':webSocketProvider.dropOffLocationsList,
                                        'riderNames':webSocketProvider.riderNames
                                      }
                                      );
                                }
                              : null,
                          isEnabled: isRideRequested,
                          boxcolor: Colors.white,
                          textColor: Colors.green,
                        ),
                        rideButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          text: "Cancel Ride",
                          textsize: 16,
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.40,
                          borderColor: Colors.red,
                          onPressed: isRideRequested
                              ? () {
                                  _webSocketProvider?.declineRide();
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
}
