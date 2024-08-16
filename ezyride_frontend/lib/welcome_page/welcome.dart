// ignore_for_file: prefer_const_constructors

import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration:const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xFFCDE9FF), Color(0xFFD9E7F1), Color(0xFFE4E4E4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
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
                        // Handle tap
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: CustomText(
                          text: "Check Availablity",
                          fontSize: 16,
                          textAlign: TextAlign.center,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: () {
                        // Handle tap
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: CustomText(
                          text: "Start Riding",
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
