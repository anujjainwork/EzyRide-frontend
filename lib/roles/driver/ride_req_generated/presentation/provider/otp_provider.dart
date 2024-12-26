import 'package:ezyride_frontend/roles/driver/ride_req_generated/data/otp_repo_impl.dart';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier{
  String _otp = '';

  String get otp => _otp;

  void setOtp(String otp){
    _otp = otp;
  }

  Future<void> getOtp() async {
    final otpRepo = OtpRepoImpl();
    await otpRepo.getOtp().then((value) => setOtp(value));
    notifyListeners();
  }
}