import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class AuthService {

  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/login"),
      headers: {
        "Accept": "application/json"
      },
      body: {
        "email": email,
        "password": password,
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      String confirmPassword,
    ) async {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/register"),
        headers: {"Accept": "application/json"},
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        },
      );

      return jsonDecode(response.body);
    }

// Kirim email reset
static Future<Map<String, dynamic>> forgotPassword(String email) async {
  final response = await http.post(
    Uri.parse("${ApiConstants.baseUrl}/forgot-password"),
    headers: {"Accept": "application/json"},
    body: {"email": email},
  );

  return jsonDecode(response.body);
}

// Verifikasi kode OTP
static Future<Map<String, dynamic>> verifyCode(
    String email, String code) async {
  final response = await http.post(
    Uri.parse("${ApiConstants.baseUrl}/verify-code"),
    headers: {"Accept": "application/json"},
    body: {
      "email": email,
      "code": code,
    },
  );

  return jsonDecode(response.body);
}

// Reset password
static Future<Map<String, dynamic>> resetPassword(
    String email, String password, String confirmPassword) async {
  final response = await http.post(
    Uri.parse("${ApiConstants.baseUrl}/reset-password"),
    headers: {"Accept": "application/json"},
    body: {
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
    },
  );

  return jsonDecode(response.body);
}

}
