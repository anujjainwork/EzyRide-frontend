import 'package:ezyride_frontend/auth/auth.dart';
import 'package:ezyride_frontend/common/constants/constants.dart';
import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/routes/routes.dart';
import 'package:ezyride_frontend/splash_screen/presentation/widget/lottie_animation_widget.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToHome() {
      Navigator.pushReplacementNamed(context, AppRouteNames.authPage);
    }

    return Scaffold(
      body: Stack(
        children: [
          LottieAnimationWidget(
            animationPath: AppConstants.lottieAnimationPath,
            onAnimationEnd: navigateToHome,
          ),
        ],
      ),
    );
  }
}
