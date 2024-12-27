import 'package:ezyride_frontend/roles/driver/google_map/presentation/custom_google_map.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/current_location_provider.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/widgets/location_widget.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/widgets/map_title.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/widgets/rider_name_widget.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/widgets/start_ride_button.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/widgets/updown_widget.dart';
import 'package:ezyride_frontend/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class DriverRideCreated extends StatefulWidget {
  final Map<String?, dynamic> arguments;
  const DriverRideCreated({super.key, required this.arguments});

  @override
  State<DriverRideCreated> createState() => _DriverRideCreatedState();
}

class _DriverRideCreatedState extends State<DriverRideCreated> {
  bool _showRiders = false; // State to toggle visibility

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrentLocationProvider>(context, listen: false)
          .getDriverCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocationProvider =
        Provider.of<CurrentLocationProvider>(context);
    final currentLocation = currentLocationProvider.currentLocation;
    Map<String?, LocationData?> dropOffLocationsList =
        widget.arguments['dropOffLocationsList'];
    List<String> riderList = widget.arguments['riderNames'];

    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  MapPage(
                    initialPosition: currentLocation,
                    dropOffLocations: dropOffLocationsList,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          getMapTitle(context, 'Ride Created'),
                          const SizedBox(height: 25),
                          locationWidget(context),
                        ],
                      ),
                    ),
                  ),
                  if (_showRiders) getEstTimeWidget(context, riderList),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showRiders = !_showRiders; // Toggle state
                          });
                        },
                        child:getUpDownWidget(_showRiders),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, AppRouteNames.ridestarted,
                          arguments: {
                            'dropOffLocationsList': dropOffLocationsList,
                            'riderNames': riderList,
                          });
                    },
                    child: getRideButton(context, Colors.green, 'Start Ride',
                        AppRouteNames.ridestarted),
                  ),
                ],
              ),
      ),
    );
  }
}
