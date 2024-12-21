import 'package:ezyride_frontend/auth/login/business/login_entity.dart';
import 'package:flutter/material.dart';

abstract class LoginRepository{
  Future<void> login(LoginEntity loginEntity,BuildContext context);
}