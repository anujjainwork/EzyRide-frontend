import 'package:ezyride_frontend/rider/check_availability/check_avail_provider.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Import latlong2 for LatLng
import 'package:provider/provider.dart';

class CheckAvail extends StatefulWidget {
  const CheckAvail({super.key});

  @override
  State<CheckAvail> createState() => _CheckAvailState();
}

class _CheckAvailState extends State<CheckAvail> {
  final MapController _mapController =
      MapController(); // Use MapController from flutter_map

  @override
  void initState() {
    super.initState();
    Provider.of<CheckAvailProvider>(context, listen: false).init();
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
                        child: Container(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.87,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            child: const Center(
                              child: CustomText(
                                text: "Driver 1 Location",
                                fontSize: 32,
                                textAlign: TextAlign.center,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      )),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.08,
                        color: Colors.black,
                        child: GestureDetector(
                          child: const Center(
                            child: CustomText(
                              text: "Switch to driver 1",
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
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Container(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.87,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(color: Colors.black)),
                          child: const Center(
                            child: CustomText(
                              text: "Driver is at the college gate.",
                              fontSize: 20,
                              textAlign: TextAlign.center,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
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
    // Properly dispose of the map controller when done
    _mapController.dispose();
    super.dispose();
  }
}
