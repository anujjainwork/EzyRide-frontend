// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:ezyride_frontend/themedata/customtextfield.dart';
import 'package:ezyride_frontend/welcome_page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // For JSON encoding


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _emergencynoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
                  text: "Sign Up",
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
                      // Enter Name
                      CustomTextField(
                        label: 'Enter Name',
                        controller: _nameController,
                        obscureText: false,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        validator: (value) {
                          final trimmedValue = value?.trim();
                          if (trimmedValue == null || trimmedValue.isEmpty) {
                            showCustomSnackbar(context, "Please enter your name");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      // Enter Year
                      CustomTextField(
                        label: 'Enter Year',
                        controller: _yearController,
                        obscureText: false,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showCustomSnackbar(context, "Please enter a year");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      // Enter Emergency contact no
                      CustomTextField(
                        label: 'Enter Emergency Contact no.',
                        controller: _emergencynoController,
                        obscureText: false,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            showCustomSnackbar(context, "Please enter an emergency no.");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
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
                      // Sign Up Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Process the sign-up here
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            final name = _nameController.text;
                            final year = _yearController.text;
                            // For example, print the credentials
                            print('Name: $name');
                            print('Year: $year');
                            print('Email: $email');
                            print('Password: $password');
                            await _signUp();
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
                          text: 'Sign Up',
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
      ),
    );
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
Future<void> _signUp() async {
  const String base = Config.baseUrl;
  const url = '$base/auth/signup'; 
try{
    final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': _nameController.text,
      'year': _yearController.text,
      'emergency_contact': _emergencynoController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      "roles":["RIDER"]
    }),
  );

  if (response.statusCode == 200) {
    // Handle success
    showCustomSnackbar(context, "Sign up successful!");
    // You can navigate to another screen or perform additional actions here
  } else {
    // Handle error
    showCustomSnackbar(context, "Sign up failed. Please try again.");
  }
}
catch(e){
  throw Exception(e);
}
}


Future<void> _login(BuildContext context) async {
  const String base = Config.baseUrl;
  final url = '$base/auth/login';

  print('Email: ${_emailController.text}');
  print('Password: ${_passwordController.text}');
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();


  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email":email,
        "password":password
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody['accessToken'];

      if (accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        print("Login successful and token saved");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
      } else {
        print("Login successful but no access token found");
      }
    } else {
      // Handle error response
      print('Failed to login: ${response.statusCode}');
      print('Error response: ${response.body}');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }
}



}