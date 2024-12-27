import 'package:ezyride_frontend/auth/login/business/login_repository.dart';
import 'package:ezyride_frontend/auth/login/data/login_model.dart';
import 'package:ezyride_frontend/auth/login/data/login_repository_impl.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;
  final LoginRepository _loginRepository = LoginRepositoryImpl();

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void login(BuildContext context) {
    final loginModel = LoginModel(email: _email, password: _password);
    _loginRepository.login(loginModel, context);
  }
}
