import 'package:ezyride_frontend/roles/driver/home/home_page.dart';
import 'package:flutter/material.dart';

class AppRouteNames{

  //splash screen

  //auth screens

  // driver screens
  static const driverHomePage = 'driver/homepage';
  static const rideRequestGenerated = 'driver/ride-request-generated';
  static const rideCreated = 'driver/ride-created';
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