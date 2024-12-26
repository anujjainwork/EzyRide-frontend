import 'package:ezyride_frontend/auth/auth.dart';
import 'package:ezyride_frontend/auth/login/presentation/provider/login_provider.dart';
import 'package:ezyride_frontend/auth/signup/presentation/provider/signup_provider.dart';
import 'package:ezyride_frontend/common/widgets/appbar/app_bar_provider.dart';
import 'package:ezyride_frontend/common/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/current_location_provider.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/ride_created_map_provider.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/presentation/provider/otp_provider.dart';
import 'package:ezyride_frontend/roles/rider/welcome_page/check_availability/check_avail_provider.dart';
import 'package:ezyride_frontend/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> LoginProvider()),
        ChangeNotifierProvider(create: (context)=> SignUpProvider()),
        ChangeNotifierProvider(create: (context)=> WebSocketProvider()),
        ChangeNotifierProvider(create: (context)=> OtpProvider()),
        ChangeNotifierProvider(create: (context)=> CurrentLocationProvider()),
        ChangeNotifierProvider(create: (context)=> RideCreatedMapProvider()),
        ChangeNotifierProvider(create: (context)=> CustomAppBarProvider()),
        ChangeNotifierProvider(create: (context) => CheckAvailProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       onGenerateRoute: AppRouter.onGenerateRoute,
      home: AuthPage (), 
    );
  }
}