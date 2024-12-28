import 'package:ezyride_frontend/common/constants/constants.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String animationPath;
  final VoidCallback onAnimationEnd;

  const LottieAnimationWidget({
    Key? key,
    required this.animationPath,
    required this.onAnimationEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFCDE9FF), Color(0xFFD9E7F1), Color(0xFFE4E4E4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                text: 'EzyRide IITN',
                fontSize: 50,
                textAlign: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              Lottie.asset(
                animationPath,
                onLoaded: (composition) {
                  Future.delayed(
                    AppConstants.splashDuration, 
                    onAnimationEnd,
                  );
                },
              ),
            ],
          )),
    );
  }
}
