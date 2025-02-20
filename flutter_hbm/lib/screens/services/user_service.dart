import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = "http://127.0.0.1:8080/user";

  static Future<Map<String, dynamic>> getUserCalories() async {
    final url = Uri.parse("$baseUrl/getCalories");
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("authentication_token");

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse["message"] ?? "Failed to get calories.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static Future<Map<String, dynamic>> getUserData() async {
    final url = Uri.parse("$baseUrl/getUserData");
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("authentication_token");

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse["message"] ?? "Failed to get user data.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}