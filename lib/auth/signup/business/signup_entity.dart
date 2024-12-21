import 'dart:convert';

import 'package:ezyride_frontend/common/constants/constants.dart';

class SignUpEntity {
  final String name;
  final String email;
  final String rollNo;
  final String password;
  final List<String> roles = ['RIDER'];

  SignUpEntity(
      {required this.name,
      required this.email,
      required this.rollNo,
      required this.password});

  Map<String, dynamic> toJson() {
    return {
      AppConstants.kName: name,
      AppConstants.kEmail: email,
      AppConstants.kRollNo: rollNo,
      AppConstants.kPassword: password,
      AppConstants.kRoles: roles
    };
  }

  factory SignUpEntity.fromJson(Map<String, dynamic> json) {
    return SignUpEntity(
      name: json[AppConstants.kName],
      email: json[AppConstants.kEmail],
      rollNo: json[AppConstants.kRollNo],
      password: json[AppConstants.kPassword],
    );
  }
}
