// ignore_for_file: prefer_const_constructors

import 'package:ezyride_frontend/auth/auth.dart';
import 'package:ezyride_frontend/roles/rider/welcome_page/check_availability/check_avail_screen.dart';
import 'package:ezyride_frontend/roles/rider/welcome_page/start_riding/enter_location.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class WelcomeRider extends StatefulWidget {
  const WelcomeRider({super.key});

  @override
  State<WelcomeRider> createState() => _WelcomeRiderState();
}

class _WelcomeRiderState extends State<WelcomeRider> {
  bool _isMenuOpen = false;
  bool _isIconEnable = true;
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
            )),
            child: Stack(
              children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0, // Remove shadow
              toolbarHeight: kToolbarHeight,
              title: Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 8.0), // Adjust this value as needed
                      child: CustomText(
                        text: "Welcome Rider",
                        fontSize: 22,
                        textAlign: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isIconEnable)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isMenuOpen = !_isMenuOpen;
                            _isIconEnable = !_isIconEnable;
                          });
                        },
                        icon: const Icon(
                          Icons.menu_outlined,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
                if (_isMenuOpen) _buildMenuBox(screenHeight, screenWidth),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckAvail()));
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
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EnterLocation()));
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

 Widget _buildMenuBox(double screenHeight, double screenWidth) {
  return Positioned(
    top: kToolbarHeight - 40,
    left: 25,
    child: Stack(
      children: [
        Container(
          height: screenHeight * 0.1,
          width: screenWidth * 0.88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.015,
              ),
              GestureDetector(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    CustomText(
                      text: "Ride history",
                      fontSize: 18,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.008,
              ),
              Container(
                height: 1,
                width: screenWidth * 0.8,
                color: Colors.black.withOpacity(0.5),
              ),
              SizedBox(
                height: screenHeight * 0.009,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: screenHeight * 0.2,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 35),
                                child: CustomText(
                                  text: "Log out?",
                                  fontSize: 24,
                                  textAlign: TextAlign.center,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                        _showSuccessDialog(screenHeight, screenWidth);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        shadowColor: Colors.transparent,
                                        side: const BorderSide(color: Colors.black),
                                      ),
                                      child: const CustomText(
                                        text: "Yes",
                                        fontSize: 16,
                                        color: Colors.black,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: const CustomText(
                                        text: "No",
                                        fontSize: 16,
                                        color: Colors.white,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_outlined),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      CustomText(
                        text: "Log out",
                        fontSize: 18,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isIconEnable = !_isIconEnable;
                _isMenuOpen = !_isMenuOpen;
              });
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ],
    ),
  );
}


  void _showSuccessDialog(double screenHeight, double screenWidth) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: screenHeight * 0.23,
            width: screenWidth * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CustomText(
                    text: "Logged out successfully",
                    fontSize: 24,
                    textAlign: TextAlign.center,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.check_circle,
                  color: Colors.green, // Customize the color as needed
                  size: 70,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Button color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      shadowColor: Colors.transparent,
                      side: const BorderSide(color: Colors.black)),
                  child: Text("Ok"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
