import 'package:ezyride_frontend/auth/login/presentation/widgets/login_form.dart';
import 'package:ezyride_frontend/auth/login/presentation/widgets/background.dart';
import 'package:ezyride_frontend/auth/login/presentation/widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:ezyride_frontend/auth/login/data/login_model.dart';
import 'package:ezyride_frontend/common/theme/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: const [
            // Background Gradient
            BackgroundGradient(gradient: backgroundGradient),

            // Positioned AppBar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(
                title: "Log in",
              ),
            ),

            // Positioned Form at the top
            Positioned(
              top: kToolbarHeight + 16.0,
              left: 16.0,
              right: 16.0,
              child: SingleChildScrollView(
                child: LoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
