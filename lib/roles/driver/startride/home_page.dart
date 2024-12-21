import 'package:ezyride_frontend/roles/driver/startride/currentlocationprovider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _isMenuOpen = false;
  bool _isIconEnable = true;

  @override
  void initState() {
    super.initState();
    // Initialize LocationProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (_isMenuOpen) {
              setState(() {
                _isMenuOpen = false;
                _isIconEnable = true;
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFCDE9FF),
                  Color(0xFFD9E7F1),
                  Color(0xFFE4E4E4)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: const CustomText(
                      text: "Home",
                      fontSize: 22,
                      textAlign: TextAlign.center,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0, // Remove shadow
                    toolbarHeight: kToolbarHeight,
                    actions: [
                      if (_isIconEnable)
                        IconButton(
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
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebSocketDemo(),
                      //   ),
                      // );
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
                      child: const CustomText(
                        text: "Generate Ride",
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBox(double screenHeight, double screenWidth) {
    return Positioned(
      top: kToolbarHeight - 40,
      left: 25,
      child: Container(
        height: screenHeight * 0.1,
        width: screenWidth * 0.88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
          color: Colors.white,
        ),
        child: Column(children: [
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
                          color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Ensure dialog size fits its content
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 35),
                            child: CustomText(
                              text: "End Shift?",
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
                                      _showSuccessDialog(screenHeight,screenWidth);

                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.transparent, // Button color
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      shadowColor: Colors.transparent,
                                      side: const BorderSide(
                                          color: Colors.black)),
                                  child: const CustomText(
                                    text: "Yes",
                                    fontSize: 16,
                                    color: Colors.black,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 20), // Space between buttons
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.black, // Button color
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
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
                    text: "End Shift",
                    fontSize: 18,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

 void _showSuccessDialog(double screenHeight, double screenWidth) {
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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: CustomText(
                  text: "Shift ended successfully",
                  fontSize: 24,
                  textAlign: TextAlign.center,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 15),
              Icon(
                Icons.check_circle,
                color: Colors.green, // Customize the color as needed
                size: 80,
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
