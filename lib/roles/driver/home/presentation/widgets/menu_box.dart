import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/roles/driver/home/presentation/widgets/success_dialog.dart';
import 'package:flutter/material.dart';

Widget buildMenuBox(BuildContext context) {
    return Positioned(
      top: kToolbarHeight - 40,
      left: 25,
      child: Container(
        height: getDynamicHeight(context, 10),
        width: getDynamicWidth(context, 88),
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
            height: getDynamicHeight(context, 1.5),
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
            height: getDynamicHeight(context, 0.8),
          ),
          Container(
            height: 1,
            width: getDynamicWidth(context, 8),
            color: Colors.black.withOpacity(0.5),
          ),
          SizedBox(
            height: getDynamicHeight(context, 0.9),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      height: getDynamicHeight(context, 20),
                      width: getDynamicWidth(context, 80),
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
                                      showSuccessDialog(context);

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