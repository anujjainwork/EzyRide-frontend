import 'package:ezyride_frontend/auth/login/business/login_repository.dart';
import 'package:ezyride_frontend/auth/login/data/login_repository_impl.dart';
import 'package:ezyride_frontend/auth/signup/business/signup_repository.dart';
import 'package:ezyride_frontend/auth/signup/data/signup_model.dart';
import 'package:ezyride_frontend/auth/signup/data/signup_repository_impl.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _rollNo = '';
  String _password = '';
  int? _emergencyNo = null;
  List<String> _roles = [];

  String get email => _email;
  String get name => _name;
  String get rollNo => _rollNo;
  String get password => _password;
  int? get emergerncyNo => _emergencyNo;
  List<String> get roles => _roles;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setRollNo(String roll_no) {
    _rollNo = roll_no;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setRoles(List<String> roles) {
    _roles = roles;
    notifyListeners();
  }

  void setEmergencyNo(int emergencyNo) {
    _emergencyNo = emergerncyNo;
    notifyListeners();
  }

  final SignUpRepository _signUpRepository = SignUpRepositoryImpl();
  
  Future<void> signUp(BuildContext context) async {
    final signUpModel = SignUpModel(
        name: _name, email: _email, rollNo: _rollNo, password: _password);
    _signUpRepository.signUp(context, signUpModel);
  }
}
