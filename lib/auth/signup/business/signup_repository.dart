import 'package:ezyride_frontend/auth/signup/business/signup_entity.dart';
import 'package:flutter/material.dart';

abstract class SignUpRepository{
  Future<void> signUp(BuildContext context, SignUpEntity signUpEntity);
}