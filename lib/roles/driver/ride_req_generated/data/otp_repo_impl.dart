import 'dart:convert';

import 'package:ezyride_frontend/config.dart';
import 'package:ezyride_frontend/roles/driver/ride_req_generated/business/otp_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OtpRepoImpl extends OtpRepo{

  @override
  Future<String> getOtp() async {
  const String baseUrl = Config.baseUrl;
    const String url = "$baseUrl/requestride/getotp";
    final prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString('accessToken');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["respCode"] == 200) {
          final String receivedOtp = responseBody['respBody'];
          return receivedOtp;
        } else {
          throw Exception(
              "Response code is not 200 -> ${responseBody["respCode"]}");
        }
      } else {
        throw Exception(
            "Response status code not 200 -> ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception(e);
    }
  }
}