// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:ezyride_frontend/auth_pages/auth.dart';
import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/rider/droplocations/locations.dart';
import 'package:ezyride_frontend/rider/verifying_otp/loader_screen.dart';
import 'package:ezyride_frontend/themedata/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EnterLocation extends StatefulWidget {
  const EnterLocation({super.key});

  @override
  State<EnterLocation> createState() => _EnterLocationState();
}

class _EnterLocationState extends State<EnterLocation> {
 List<Location> locations = [];
  bool _isIconEnable = true;
  bool _isMenuOpen = false;
  String? accessToken;
  String? username;
  String? enrollmentNo;
  int? riderId;
  Location? selectedLocation;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _totalMemberController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _getUserData();
    _getAllLocations();
  }

  Future<void> _getUserData() async {
    const String baseUrl = Config.baseUrl;
    const String url = "$baseUrl/requestride/getriderdata";
    final prefs = await SharedPreferences.getInstance();
    accessToken = await prefs.getString('accessToken');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["respCode"] == 200) {
          final Map<String, dynamic> respBody = responseBody['respBody'];
          print(responseBody['respMsg']);
          print("RIDER DETAILS ${respBody}");
          setState(() {
            username = respBody["user"]["name"];
            enrollmentNo = respBody["roll_no"];
            riderId = respBody["user"]["id"];
          });
        }
      } else {
        throw Exception(
            "Response status code not 200 -> ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _getAllLocations() async {
    const String baseUrl = Config.baseUrl;
    const String url = "$baseUrl/requestride/getAllLocations";
    final prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString('accessToken');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["respCode"] == 200) {
          final List<dynamic> respBody = responseBody['respBody'];

          // Parse the location data
          final List<Location> apiLocations = respBody.map<Location>((json) {
            return Location.fromJson(json);
          }).toList();

          setState(() {
            locations = apiLocations;
            if (locations.isNotEmpty) {
              selectedLocation = locations[0];
            }
          });
          print("LOCATIONS --- $locations");
          print(responseBody['respMsg']);
        } else {
          throw Exception(
              "Response code is not 200 -> ${responseBody["respCode"]}");
        }
      } else {
        throw Exception(
            "Response status code not 200 -> ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
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
                      padding: EdgeInsets.only(top: 10.0),
                      child: CustomText(
                        text: "Ride request",
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 250),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: screenHeight * 0.37,
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 25),
                                child: const CustomText(
                                  text: "Rider name",
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, right: 25),
                                child: CustomText(
                                  text: username ?? "",
                                  fontSize: 16,
                                  textAlign: TextAlign.end,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 25),
                                child: const CustomText(
                                  text: "Enrollnment no",
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, right: 25),
                                child: CustomText(
                                  text: enrollmentNo ?? "",
                                  fontSize: 16,
                                  textAlign: TextAlign.end,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 25),
                                child: const CustomText(
                                  text: "Drop off location",
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, right: 25),
                                  child: Container(
                                      height: screenHeight * 0.04,
                                      width: screenWidth * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<Location>(
                                            value: selectedLocation,
                                            isExpanded: true,
                                            icon: Icon(Icons.arrow_drop_down,
                                                color: Colors.black),
                                            onChanged: (Location? newValue) {
                                              setState(() {
                                                selectedLocation = newValue;
                                              });
                                            },
                                            items: locations.map<
                                                    DropdownMenuItem<Location>>(
                                                (Location location) {
                                              return DropdownMenuItem<Location>(
                                                value: location,
                                                child: Center(
                                                  child: CustomText(
                                                    text: location.name,
                                                    textAlign: TextAlign.center,
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 25),
                                child: const CustomText(
                                  text: "Enter total members",
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, right: 25),
                                child: Container(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: _totalMemberController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 25),
                                child: const CustomText(
                                  text: "Enter OTP",
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, right: 25),
                                child: Container(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: _otpController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        if (_otpController.text.isEmpty ||
                            selectedLocation == null) {
                          final snackBar = SnackBar(
                            content: CustomText(
                              text: _otpController.text.isEmpty
                                  ? 'Please enter the OTP.'
                                  : _totalMemberController.text.isEmpty
                                  ?'Please enter total members riding':'Please select a drop-off location.',
                              textAlign: TextAlign.center,
                              color: Colors.white,
                              fontSize: 14, 
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.black,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoaderScreen(
                                      dropLocationCoordinates:
                                          selectedLocation!.coordinates,
                                      dropLocation: selectedLocation!.name,
                                      riderId: riderId!,
                                      username: username!,
                                      otp: _otpController.text,
                                      totalMembers:_totalMemberController.text)));
                        }
                      },
                      child: Container(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Request ride",
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                'lib/assets/images/autorickshaw.svg',
                width: screenWidth,
                fit: BoxFit.contain,
                semanticsLabel: 'A description of the SVG image',
              ),
            ),
          ],
        ),
      ),
    ));
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
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                          _showSuccessDialog(
                                              screenHeight, screenWidth);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          shadowColor: Colors.transparent,
                                          side: const BorderSide(
                                              color: Colors.black),
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
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
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
              child: const Icon(
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
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CustomText(
                    text: "Logged out successfully",
                    fontSize: 24,
                    textAlign: TextAlign.center,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green, // Customize the color as needed
                  size: 70,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Button color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      shadowColor: Colors.transparent,
                      side: const BorderSide(color: Colors.black)),
                  child: const Text("Ok"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
