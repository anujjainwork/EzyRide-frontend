import 'package:ezyride_frontend/common/constants/constants.dart';

class LoginEntity {
  final String email;
  final String password;

  LoginEntity({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      AppConstants.kEmail: email,
      AppConstants.kPassword: password,
    };
  }

  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    return LoginEntity(
      email: json[AppConstants.kEmail] as String,
      password: json[AppConstants.kPassword] as String,
    );
  }
}
