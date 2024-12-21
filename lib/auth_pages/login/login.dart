// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/driver/startride/welcome.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:ezyride_frontend/themedata/customtextfield.dart';
import 'package:ezyride_frontend/rider/welcome_page/welcome_rider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFCDE9FF), Color(0xFFD9E7F1), Color(0xFFE4E4E4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Positioned AppBar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                title: const CustomText(
                  text: "Log in",
                  fontSize: 22,
                  textAlign: TextAlign.center,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0, // Remove shadow
                toolbarHeight: kToolbarHeight,
              ),
            ),
            // Positioned Form at the top
            Positioned(
              top: kToolbarHeight + 16.0, // Position below the AppBar
              left: 16.0,
              right: 16.0,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Email Field
                      CustomTextField(
                        label: 'Enter Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showCustomSnackbar(context, "Please enter an email");
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value??"")) {
                            showCustomSnackbar(context, "Please enter a valid email");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Password Field
                      CustomTextField(
                        label: 'Enter Password',
                        controller: _passwordController,
                        obscureText: true,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showCustomSnackbar(context, "Please enter a password");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 70.0),
                      // Login Up Button
                      ElevatedButton(
                        onPressed: () async{
                          if (_formKey.currentState?.validate() ?? false) {
                            // Process the login here
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            // For example, print the credentials
                            print('Email: $email');
                            print('Password: $password');
                            await _login(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Background color of the button
                          minimumSize: Size(screenWidth * 0.5,
                              screenHeight * 0.04), // Size of the button (width and height)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Rounded corners of the button
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0), // Padding inside the button
                        ),
                        child: const CustomText(
                          text: 'Log in',
                          fontSize: 16,
                          color: Colors.white,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold ,
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    ));
  }

void showCustomSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

Future<void> _login(BuildContext context) async {
  const String base = Config.baseUrl;
  final url = '$base/auth/login'; // Use the base URL from config

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Check if the response contains an access token
      final String accessToken = responseBody['accessToken'];
      final String refreshToken = responseBody['refreshToken'];
      final List<dynamic> rolesDynamic = responseBody['roles'];

        // Convert List<dynamic> to List<String>
        final List<String> roles = rolesDynamic.cast<String>();
      if (accessToken != null) {
        // Save the access token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setStringList('roles',roles);
        print("Login successful, tokens and roles saved");

        // Navigate to the Welcome screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => 
          roles.contains("DRIVER")?
          WelcomeDriver():WelcomeRider()),
        );
      } else {
        print("Login successful but no access token found");
      }
    } else {
      // Handle unsuccessful login (e.g., show error message)
      print('Failed to login: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions
    print('Exception occurred: $e');
  }
}
}