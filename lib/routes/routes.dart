import 'package:ezyride_frontend/routes/routing_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:ezyride_frontend/auth/auth.dart';
import 'package:ezyride_frontend/roles/driver/home/presentation/views/home.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/ride_created_screen.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/views/ride_req_generated.dart';
import 'package:ezyride_frontend/roles/driver/ride_started/presentation/ride_started_screen.dart';
import 'package:ezyride_frontend/roles/rider/welcome_page/welcome_rider.dart';

class AppRouteNames {
  // Splash screen
  static const authPage = 'auth';
  // Driver screens
  static const driverHomePage = 'driver/homepage';
  static const driverRideRequestGenerated = 'driver/ride-request-generated';
  static const driverRideCreated = 'driver/ride-created';
  static const ridestarted = 'driver/ride-started';
  // Rider screens
  static const riderHomePage = 'rider/homepage';
  static const riderCheckRideAvailability = 'rider/check-availability';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.authPage:
        return _buildFadePageRoute(
          const AuthPage(),
          name: AppRouteNames.authPage,
        );
      case AppRouteNames.driverHomePage:
        return _buildFadePageRoute(
          const DriverHomePage(),
          name: AppRouteNames.driverHomePage,
        );
      case AppRouteNames.riderHomePage:
        return _buildFadePageRoute(
          const RiderHomePage(),
          name: AppRouteNames.riderHomePage,
        );
      case AppRouteNames.driverRideRequestGenerated:
        return _buildFadePageRoute(
          const DriverRideReqGenerated(),
          name: AppRouteNames.driverRideRequestGenerated,
        );
      case AppRouteNames.driverRideCreated:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildFadePageRoute(
          DriverRideCreated(arguments: args),
          name: AppRouteNames.driverRideCreated,
        );
      case AppRouteNames.ridestarted:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildFadePageRoute(
          DriverRideStarted(arguments: args),
          name: AppRouteNames.ridestarted,
        );
      default:
        return _buildFadePageRoute(const Scaffold());
    }
  }

  static Route<dynamic> _buildFadePageRoute(Widget widget, {String? name}) {
    return FadePageRoute(
      page: widget,
      duration: const Duration(milliseconds: 200),
    );
  }
}
