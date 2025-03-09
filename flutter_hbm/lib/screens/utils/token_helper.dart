import 'dart:convert';

class TokenHelper {
  static String extractUserIdFromToken(String token) {
    try {
      List<String> tokenParts = token.split('.');
      if (tokenParts.length != 3) {
        return 'Invalid token format';
      }

      String payload = tokenParts[1];
      String normalizedPayload = base64.normalize(payload);
      String decodedPayload = utf8.decode(base64.decode(normalizedPayload));

      Map<String, dynamic> payloadMap = json.decode(decodedPayload);
      return payloadMap['user_id'].toString();
    } catch (e) {
      return e.toString();
    }
  }
}