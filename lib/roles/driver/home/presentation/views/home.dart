import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/appbar/app_bar_provider.dart';
import 'package:ezyride_frontend/common/widgets/appbar/custom_app_bar.dart';
import 'package:ezyride_frontend/roles/driver/home/presentation/widgets/menu_box.dart';
import 'package:ezyride_frontend/common/websocket_connections/websocket_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {

  @override
  void initState() {
    super.initState();
    // Initialize WebSocketProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebSocketProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarProvider = Provider.of<CustomAppBarProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (appBarProvider.isMenuOpen) {
              setState(() {
                appBarProvider.setIsIconEnable(true);
                appBarProvider.setIsMenuOpen(false);
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
                  child: CustomAppBar(),
                ),
                if (appBarProvider.isMenuOpen) buildMenuBox(context),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    'lib/assets/images/autorickshaw.svg',
                    width: getDynamicWidth(context, 100),
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouteNames.driverRideRequestGenerated);
                    },
                    child: Container(
                      height: getDynamicHeight(context, 5),
                      width: getDynamicWidth(context, 75),
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
}
