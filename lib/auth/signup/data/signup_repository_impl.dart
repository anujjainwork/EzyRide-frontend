import 'dart:convert';

import 'package:ezyride_frontend/auth/login/business/login_entity.dart';
import 'package:ezyride_frontend/auth/login/business/login_repository.dart';
import 'package:ezyride_frontend/auth/login/data/login_repository_impl.dart';
import 'package:ezyride_frontend/auth/signup/business/signup_entity.dart';
import 'package:ezyride_frontend/auth/signup/business/signup_repository.dart';
import 'package:ezyride_frontend/common/widgets/custom_snack_bar.dart';
import 'package:ezyride_frontend/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpRepositoryImpl implements SignUpRepository {
  final LoginRepository _loginRepository = LoginRepositoryImpl();

  @override
  Future<void> signUp(BuildContext context, SignUpEntity signUpEntity) async {
    const String base = Config.baseUrl;
    const url = '$base/auth/signup';
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(signUpEntity.toJson()));

      if (response.statusCode == 200) {
        showCustomSnackbar(context, "Sign up successful!");
        final loginEntity = LoginEntity(email: signUpEntity.email, password: signUpEntity.password);
        _loginRepository.login(loginEntity, context);
      } else {
        showCustomSnackbar(context, "Sign up failed. Please try again.");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
