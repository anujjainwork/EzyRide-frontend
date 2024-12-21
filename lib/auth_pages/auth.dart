import 'package:ezyride_frontend/auth_pages/login/login.dart';
import 'package:ezyride_frontend/auth_pages/signup/signup.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFCDE9FF), Color(0xFFD9E7F1), Color(0xFFE4E4E4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              Align(
                alignment: const Alignment(0.0, -0.3), // Adjust to move up slightly from the center
                child: SvgPicture.asset(
                  'lib/assets/images/ezyridelogo.svg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  semanticsLabel: 'A description of the SVG image',
                ),
              ),
              const SizedBox(height: 20), // Add spacing between the image and the text
              const CustomText(
                text: "Welcome",
                fontSize: 22,
                textAlign: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  // Navigate to the Welcome screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const CustomText(
                          text: "Sign Up",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                InkWell(
                onTap: () {
                  // Navigate to the Welcome screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const CustomText(
                          text: "Log in",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
