import 'package:ezyride_frontend/auth/signup/presentation/provider/signup_provider.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/common/widgets/custom_text_field.dart';
import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController nameController;
  late TextEditingController rollNoController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    // Initialize controllers with values from the provider
    nameController = TextEditingController(text: signUpProvider.name);
    rollNoController = TextEditingController(text: signUpProvider.rollNo);
    emailController = TextEditingController(text: signUpProvider.email);
    passwordController = TextEditingController(text: signUpProvider.password);
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    rollNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Name Field
          CustomTextField(
            label: 'Enter Name',
            controller: nameController,
            obscureText: false,
            screenHeight: getDynamicHeight(context, 100),
            screenWidth: getDynamicWidth(context, 100),
            validator: (value) {
              if (value == null || value.isEmpty) {
                showCustomSnackbar(context, "Please enter a name");
              }
              return null;
            },
            onChanged: (value) => signUpProvider.setName(value),
          ),
          SizedBox(height: getDynamicHeight(context, 3)),

          // Roll No Field
          CustomTextField(
            label: 'Enter Roll No.',
            controller: rollNoController,
            obscureText: false,
            screenHeight: getDynamicHeight(context, 100),
            screenWidth: getDynamicWidth(context, 100),
            validator: (value) {
              final pattern = r'^BT\d{2}[A-Z]{3}\d{3}$';
              final regExp = RegExp(pattern);
              if (value == null || value.isEmpty) {
                showCustomSnackbar(context, "Please enter a roll number");
              } else if (!regExp.hasMatch(value)) {
                showCustomSnackbar(context,
                    "Please enter a valid roll number in the format BT00ABC000");
              }
              return null;
            },
            onChanged: (value) => signUpProvider.setRollNo(value),
          ),
          SizedBox(height: getDynamicHeight(context, 3)),

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
            onChanged: (value) => signUpProvider.setEmail(value),
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
            onChanged: (value) => signUpProvider.setPassword(value),
          ),
          SizedBox(height: getDynamicHeight(context, 10)),

          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                signUpProvider.signUp(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(
                getDynamicHeight(context, 50),
                getDynamicWidth(context, 3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: const CustomText(
              text: 'Sign up',
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
