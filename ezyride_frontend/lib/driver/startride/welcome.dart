// ignore_for_file: prefer_const_constructors

import 'package:ezyride_frontend/driver/startride/home_page.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class WelcomeDriver extends StatefulWidget {
  const WelcomeDriver({super.key});

  @override
  State<WelcomeDriver> createState() => _WelcomeDriverState();
}

class _WelcomeDriverState extends State<WelcomeDriver> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  'lib/assets/images/autorickshaw.svg',
                  width: screenWidth,
                  fit: BoxFit.contain,
                  semanticsLabel: 'A description of the SVG image',
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverHomePage(),
                          ),
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CustomText(
                          text: "Start Shift",
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
