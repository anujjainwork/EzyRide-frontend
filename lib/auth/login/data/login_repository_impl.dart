// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ezyride_frontend/auth/login/business/login_entity.dart';
import 'package:ezyride_frontend/auth/login/business/login_repository.dart';
import 'package:ezyride_frontend/auth/login/data/login_model.dart';
import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginRepositoryImpl implements LoginRepository {
  Future<void> login(LoginEntity loginEntity, BuildContext context) async {
    const String base = Config.baseUrl;
    const url = '$base/auth/login'; // Use the base URL from config

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginEntity.toJson()),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        final String accessToken = responseBody['accessToken'];
        final String refreshToken = responseBody['refreshToken'];
        final List<dynamic> rolesDynamic = responseBody['roles'];
        final List<String> roles = rolesDynamic.cast<String>();
        if (accessToken != null) {

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('refreshToken', refreshToken);
          await prefs.setStringList('roles', roles);

          print("Login successful, tokens and roles saved");

          roles.contains('DRIVER')
              ? Navigator.of(context)
                  .pushReplacementNamed(AppRouteNames.driverHomePage)
              : Navigator.of(context)
                  .pushReplacementNamed(AppRouteNames.riderHomePage);
        } else {
          print("Login successful but no access token found");
        }
      } else {
        print('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}
