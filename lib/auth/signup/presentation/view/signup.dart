// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:ezyride_frontend/auth/login/presentation/widgets/background.dart';
import 'package:ezyride_frontend/auth/login/presentation/widgets/customAppBar.dart';
import 'package:ezyride_frontend/auth/signup/presentation/widgets/signup_form.dart';
import 'package:ezyride_frontend/common/theme/colors.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: const [
            BackgroundGradient(gradient: backgroundGradient),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(
                title: "Sign up",
              ),
            ),
            Positioned(
              top: kToolbarHeight + 16.0,
              left: 16.0,
              right: 16.0,
              child: SingleChildScrollView(
                child: SignUpForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
