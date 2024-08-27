import 'package:ezyride_frontend/auth_pages/auth.dart';
import 'package:ezyride_frontend/driver/startride/currentlocationprovider.dart';
import 'package:ezyride_frontend/driver/startride/welcome.dart';
import 'package:ezyride_frontend/rider/welcome_page/check_availability/check_avail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
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

//have to change it

      home: AuthPage (), 
    );
  }
}