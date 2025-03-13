import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChartsService {
  static const String baseUrl = "http://127.0.0.1:8080/chart";

  static Future<Map<String, dynamic>> getChartDataForAPeriod(int days, String chartType) async {
    final url = Uri.parse("$baseUrl/getChartDataForAPeriod?days=$days&chartType=$chartType");
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
        throw Exception(errorResponse["message"] ?? "Failed to get chart data.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
