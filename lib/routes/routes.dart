import 'package:ezyride_frontend/roles/driver/home/presentation/views/home.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/ride_created_screen.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/views/ride_req_generated.dart';
import 'package:ezyride_frontend/roles/rider/welcome_page/welcome_rider.dart';
import 'package:flutter/material.dart';

class AppRouteNames{

  //splash screen

  //auth screens

  // driver screens
  static const driverHomePage = 'driver/homepage';
  static const driverRideRequestGenerated = 'driver/ride-request-generated';
  static const driverRideCreated = 'driver/ride-created';
  static const ridestarted = 'driver/ride-started';

  //rider screens
  static const riderHomePage = 'rider/homepage';
  static const riderCheckRideAvailability = 'rider/check-availability';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.driverHomePage:
        return _buildMaterialPageRoute(
          const DriverHomePage(),
          name: AppRouteNames.driverHomePage,
        );
      case AppRouteNames.riderHomePage:
        return _buildMaterialPageRoute(
          const RiderHomePage(),
          name: AppRouteNames.riderHomePage,
        );
      case AppRouteNames.driverRideRequestGenerated:
        return _buildMaterialPageRoute(
          const DriverRideReqGenerated(),
          name: AppRouteNames.driverRideRequestGenerated,
        );
      case AppRouteNames.driverRideCreated:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildMaterialPageRoute(
          DriverRideCreated(arguments: args),  // Pass the arguments to the widget
          name: AppRouteNames.driverRideCreated,
        );
      // case AppRouteNames.ridestarted:
      //   return _buildMaterialPageRoute(
      //     const DriverRideStarted(),
      //     name: AppRouteNames.ridestarted,
      //   );
      
      default:
        return _buildMaterialPageRoute(const Scaffold());
    }
  }

  static Route<dynamic> _buildMaterialPageRoute(Widget widget, {String? name}) {
    return MaterialPageRoute(
      builder: (_) => widget,
      settings: RouteSettings(name: name),
    );
  }
}