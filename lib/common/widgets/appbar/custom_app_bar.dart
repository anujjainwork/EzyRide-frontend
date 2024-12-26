import 'package:ezyride_frontend/common/widgets/appbar/app_bar_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final appBarProvider = Provider.of<CustomAppBarProvider>(context);
    return  AppBar(
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
                      if (appBarProvider.isIconEnable)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              appBarProvider.setIsIconEnable(!appBarProvider.isIconEnable);
                              appBarProvider.setIsMenuOpen(!appBarProvider.isMenuOpen);
                            });
                          },
                          icon: const Icon(
                            Icons.menu_outlined,
                            size: 32,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  );
}
  }