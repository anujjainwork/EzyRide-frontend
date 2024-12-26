import 'dart:convert';

import 'package:ezyride_frontend/common/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DriverStartRide extends StatefulWidget {
  final String dropOffLocationName;
  final LocationData dropOffLocationData;

  const DriverStartRide({
    super.key,
    required this.dropOffLocationName,
    required this.dropOffLocationData
  });

  @override
  State<DriverStartRide> createState() => _DriverStartRideState();
}

class _DriverStartRideState extends State<DriverStartRide> {

  String? distanceLeft;
  String? estimatedTime;
  final MapController _mapController = MapController();

@override
  void initState() {
    super.initState();
    _fetchDistanceAndTime();
  }

@override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Consumer<WebSocketProvider>(
          builder: (context, locationProvider, child) {
            if (locationProvider.locationData != null) {
              LatLng currentLocation = LatLng(
                locationProvider.locationData!.latitude!,
                locationProvider.locationData!.longitude!,
              );

              return Stack(
                children: [
                  Positioned.fill(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: currentLocation, // Set initial center
                        initialZoom: 14.0, // Set initial zoom
                        minZoom: 5.0, // Set minimum zoom level if needed
                        maxZoom: 18.0, // Set maximum zoom level if needed
                        onMapReady: () {
                          // Map is ready callback if needed
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // Updated URL
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            if (locationProvider.locationData !=
                                null) // Check if driver location is available
                              Marker(
                                point: LatLng(
                                  locationProvider.locationData!.latitude!,
                                  locationProvider.locationData!.longitude!,
                                ),
                                child: const Icon(Icons.location_pin,
                                    color: Color.fromRGBO(237, 28, 36, 100)), // Marker style
                                width: 80.0,
                                height: 80.0,
                                rotate: false, // Set rotation if needed
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                  height: screenHeight * 0.06,
                                  width: screenWidth * 0.87,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: CustomText(
                                      text: "Ride Created",
                                      fontSize: 32,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              const SizedBox(
                                height: 25,
                              ),
                              // Opacity(
                              //   opacity: 0.7,
                              //   child: Container(
                              //       height: screenHeight * 0.105,
                              //       width: screenWidth * 0.87,
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(15),
                              //         color: Colors.white,
                              //         border: Border.all(color: Colors.black),
                              //         boxShadow: const [
                              //           BoxShadow(
                              //             color: Colors.black26,
                              //             blurRadius: 5,
                              //             offset: Offset(0, 2),
                              //           ),
                              //         ],
                              //       ),
                              //       padding: const EdgeInsets.only(
                              //           top: 15,
                              //           right: 20,
                              //           left: 20,
                              //           bottom: 10),
                              //       child: Column(
                              //         children: [
                              //           const Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               CustomText(
                              //                 text: "Pick Up Location",
                              //                 fontSize: 18,
                              //                 textAlign: TextAlign.center,
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //               CustomText(
                              //                 text: "IIITN",
                              //                 fontSize: 18,
                              //                 textAlign: TextAlign.center,
                              //                 color: Colors.green,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ],
                              //           ),
                              //           SizedBox(
                              //             height: screenHeight * 0.005,
                              //           ),
                              //           Container(
                              //             height: 1,
                              //             color: Colors.black,
                              //           ),
                              //           SizedBox(
                              //             height: screenHeight * 0.01,
                              //           ),
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               const CustomText(
                              //                 text: "Drop Location",
                              //                 fontSize: 18,
                              //                 textAlign: TextAlign.center,
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //               CustomText(
                              //                 text: widget.dropOffLocationName??" ",
                              //                 fontSize: 18,
                              //                 textAlign: TextAlign.center,
                              //                 color: Colors.green,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       )),
                              // ),
                            ],
                          ))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.07,
                        color: Colors.green,
                        child: GestureDetector(
                          child: const Center(
                            child: CustomText(
                              text: "Start Ride",
                              fontSize: 20,
                              textAlign: TextAlign.center,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                            height: screenHeight * 0.105,
                            width: screenWidth * 0.87,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                top: 15, right: 20, left: 20, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      text: "Rider name",
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    CustomText(
                                      text: distanceLeft ?? "Calculating...",
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      text: "Est. time",
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    CustomText(
                                      text: estimatedTime ?? "Estimating...",
                                      fontSize: 18,
                                      textAlign: TextAlign.center,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _fetchDistanceAndTime() async {
    final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
    if (webSocketProvider.dropOffLocationData != null) {
      final dropLatLangs = webSocketProvider.dropOffLocationData;
      final driverLocation = webSocketProvider.locationData;
      try {
        final osrmUrl =
            'http://router.project-osrm.org/route/v1/driving/79.02613286808447,20.950470506754225;${dropLatLangs!.longitude},${dropLatLangs.latitude}?overview=false';

        final response = await http.get(Uri.parse(osrmUrl));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final route = json['routes'][0];
          final distance = route['distance']; // distance in meters
          final duration = route['duration']; // duration in seconds

          setState(() {
            distanceLeft = (distance / 1000).toStringAsFixed(2) + " km"; // Convert to km
            estimatedTime = (duration / 60).toStringAsFixed(0) + " min"; // Convert to minutes
          });
        } else {
          throw Exception("Failed to load OSRM data");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}