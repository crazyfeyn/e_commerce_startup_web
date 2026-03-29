import 'dart:convert';

class JwtUtils {
  static Map<String, dynamic>? decodePayload(String jwt) {
    final parts = jwt.split('.');
    if (parts.length != 3) return null;

    try {
      final normalized = base64Url.normalize(parts[1]);
      final bytes = base64Url.decode(normalized);
      final jsonMap = json.decode(utf8.decode(bytes));
      return jsonMap is Map<String, dynamic> ? jsonMap : null;
    } catch (_) {
      return null;
    }
  }

  static String? extractClientId(String jwt) {
    final payload = decodePayload(jwt);
    final clientId = payload?['clientId'];
    if (clientId is String && clientId.isNotEmpty) return clientId;
    return null;
  }
}

