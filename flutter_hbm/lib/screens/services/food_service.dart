import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FoodService {
  static const String baseUrl = "http://127.0.0.1:8080/food";

  static Future<Map<String, dynamic>> getFoodByName(String foodName) async {
    final url = Uri.parse("$baseUrl/searchByName?foodName=$foodName");
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
        throw Exception(errorResponse["message"] ?? "Failed to get food.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> saveFoodIntake(Map<String, dynamic> foodIntake) async {
    final url = Uri.parse("$baseUrl/saveFoodIntake");
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("authentication_token");

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(foodIntake),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse["message"] ?? "Failed to save food intake.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<dynamic>> getFoodIntakesByDate(String date) async {
    final url = Uri.parse("$baseUrl/getFoodIntakesByDate?date=$date");
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
        throw Exception(errorResponse["message"] ?? "Failed to get food.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static Future<void> deleteFoodIntake(int id) async {
    final url = Uri.parse("$baseUrl/deleteFoodIntake/$id");
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("authentication_token");

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to delete food intake.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static Future<void> updateFoodIntake(Map<String, dynamic> updateFoodIntake) async {
    final url = Uri.parse("$baseUrl/updateFoodIntake");
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("authentication_token");

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    try {
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(updateFoodIntake)
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update food intake.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}