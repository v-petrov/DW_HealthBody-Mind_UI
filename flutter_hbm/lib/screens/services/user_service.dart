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
  static Future<Map<String, dynamic>> saveUserCalories(int calories, int carbs, int fats, int protein, double water) async {
    final url = Uri.parse("$baseUrl/saveUserCalories");
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
        body: jsonEncode({
          "calories" : calories,
          "protein" : protein,
          "carbs" : carbs,
          "fats" : fats,
          "water" : water
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse["message"] ?? "Failed to save user calories.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> saveUserProfile(double weight, double goalWeight, String goal, String weeklyGoal, String activityLevel, int steps, bool stepsFlag) async {
    final url = Uri.parse("$baseUrl/saveUserProfile");
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
        body: jsonEncode({
          "weight" : weight,
          "goalWeight" : goalWeight,
          "goal" : goal,
          "weeklyGoal" : weeklyGoal,
          "activityLevel" : activityLevel,
          "steps" : steps,
          "stepsFlag" : stepsFlag
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse["message"] ?? "Failed to save user calories.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getProfilePicture() async {
    final url = Uri.parse("$baseUrl/getProfilePicture");
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
        throw Exception(errorResponse["message"] ?? "Failed to get profile picture.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> updateProfilePicture(String imageUrl) async {
    final url = Uri.parse("$baseUrl/updateProfilePicture");
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
        body: jsonEncode({"profilePictureUrl": imageUrl}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update profile picture.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}