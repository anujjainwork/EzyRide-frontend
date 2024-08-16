import 'package:ezyride_frontend/auth_pages/auth.dart';
import 'package:ezyride_frontend/auth_pages/login/login.dart';
import 'package:ezyride_frontend/auth_pages/signup/signup.dart';
import 'package:ezyride_frontend/welcome_page/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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