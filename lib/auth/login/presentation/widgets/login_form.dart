import 'dart:math';

import 'package:ezyride_frontend/auth/login/presentation/provider/login_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/common/widgets/custom_text_field.dart';
import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Initialize controllers with values from the provider
    emailController = TextEditingController(text: loginProvider.email);
    passwordController = TextEditingController(text: loginProvider.password);
  }

  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Email Field
          CustomTextField(
            label: 'Enter Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            screenHeight: getDynamicHeight(context, 100),
            screenWidth: getDynamicWidth(context, 100),
            validator: (value) {
              if (value == null || value.isEmpty) {
                showCustomSnackbar(context, "Please enter an email");
                return 'Please enter an email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                showCustomSnackbar(context, "Please enter a valid email");
              }
              return null;
            },
            onChanged: (value) => loginProvider.setEmail(value),
          ),
          SizedBox(height: getDynamicHeight(context, 3)),

          // Password Field
          CustomTextField(
            label: 'Enter Password',
            controller: passwordController,
            obscureText: true,
            screenHeight: getDynamicHeight(context, 100),
            screenWidth: getDynamicWidth(context, 100),
            validator: (value) {
              if (value == null || value.isEmpty) {
                showCustomSnackbar(context, "Please enter a password");
              }
              return null;
            },
            onChanged: (value) => loginProvider.setPassword(value),
          ),
          SizedBox(height: getDynamicHeight(context, 7)),

          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                loginProvider.login(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(
                getDynamicHeight(context, 20),
                getDynamicWidth(context, 3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: const CustomText(
              text: 'Log in',
              fontSize: 16,
              color: Colors.white,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
