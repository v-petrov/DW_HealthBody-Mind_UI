import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ChatRecommendationService {
  static const String baseUrl = "http://127.0.0.1:8080/recommendation";

  static Future<String> getDialogFlowAnswer(String message) async {
    final url = Uri.parse("$baseUrl/sendQuestionToDialogflow");
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
        body: jsonEncode({
          "queryInput": {
            "text": {"text": message, "languageCode": "en"},
          },
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData["queryResult"]["fulfillmentText"] ?? "Sorry, I didn't understand.";
      } else {
        return "Error: AI service is unavailable.";
      }
    } catch (e) {
      throw Exception("Error: Could not connect to AI.");
    }
  }

  static Future<Map<String, dynamic>> getDailyRecommendation(Map<String, dynamic> userData) async {
    final url = Uri.parse("$baseUrl/getDailyRecommendation");
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
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse["message"] ?? "Failed to get daily recommendation.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}