// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:ezyride_frontend/roles/rider/check_availability/check_avail_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RiderRideStarted extends StatefulWidget {
  final List<double> dropLocationCoordinates;
  final String dropLocation;

  const RiderRideStarted({super.key,
  required this.dropLocationCoordinates,
  required this.dropLocation
  });

  @override
  State<RiderRideStarted> createState() => _RiderRideStartedState();
}

class _RiderRideStartedState extends State<RiderRideStarted> {
  
  String? distanceLeft;
  String? estimatedTime;
  final MapController _mapController =
      MapController();

  @override
  void initState() {
    super.initState();
    Provider.of<CheckAvailProvider>(context, listen: false).init();
    _fetchDistanceAndTime();
     // Start listening to location updates
    Provider.of<CheckAvailProvider>(context, listen: false).addListener(_onLocationUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Consumer<CheckAvailProvider>(
          builder: (context, locationProvider, child) {
            if (locationProvider.latitude != null &&
                locationProvider.longitude != null) {
              LatLng currentLocation = LatLng(
                locationProvider.latitude!,
                locationProvider.longitude!,
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
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: currentLocation,
                              child: const Icon(Icons.location_pin,
                                  color: Colors
                                      .red), // Use child to display the marker
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
                                      text: "Ride Started",
                                      fontSize: 32,
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              const SizedBox(
                                height: 25,
                              ),
                              Opacity(
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
                                    padding: EdgeInsets.only(
                                        top: 15,
                                        right: 20,
                                        left: 20,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: "Pick Up Location",
                                              fontSize: 18,
                                              textAlign: TextAlign.center,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            CustomText(
                                              text: "IIITN",
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
                                            CustomText(
                                              text: "Drop Location",
                                              fontSize: 18,
                                              textAlign: TextAlign.center,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            CustomText(
                                              text: widget.dropLocation??"",
                                              fontSize: 18,
                                              textAlign: TextAlign.center,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.07,
                        color: Colors.black,
                        child: GestureDetector(
                          child: const Center(
                            child: CustomText(
                              text: "Call Emergency Contact",
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
                            padding: EdgeInsets.only(
                                top: 15, right: 20, left: 20, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "Distance left",
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
                                    CustomText(
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

  @override
  void dispose() {
    // Dispose of the location listener when the widget is destroyed
    Provider.of<CheckAvailProvider>(context, listen: false).removeListener(_onLocationUpdate);
    _mapController.dispose();
    super.dispose();
  }

  void _onLocationUpdate() {
    _fetchDistanceAndTime();
  }

  Future<void> _fetchDistanceAndTime() async {
    final locationProvider = Provider.of<CheckAvailProvider>(context, listen: false);
    if (locationProvider.latitude != null && locationProvider.longitude != null) {
      LatLng driverLocation = LatLng(locationProvider.latitude!, locationProvider.longitude!);
      LatLng dropLatLangs = LatLng(widget.dropLocationCoordinates[0], widget.dropLocationCoordinates[1]);

      try {
        final osrmUrl =
            'http://router.project-osrm.org/route/v1/driving/${driverLocation.longitude},${driverLocation.latitude};${dropLatLangs.longitude},${dropLatLangs.latitude}?overview=false';

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
