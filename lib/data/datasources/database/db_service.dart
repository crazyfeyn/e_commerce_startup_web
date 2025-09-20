//
// class DBService {
//   static final ensure = DBService();
//
//   // DBService() {
//   //   _refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjbGllbnRJZCI6IjI5MjdjYmExLTZiMzAtNGEyNi05MDg4LWVlMzM4MzMzY2Y2OSJ9.rTNKil_rzn0lHRqHB8Bu7G5y4wmtyqO6nmQUX-JEBm0";
//   //   _accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkZXZpY2VUeXBlIjoiaW9zIiwiY2xpZW50SWQiOiIyOTI3Y2JhMS02YjMwLTRhMjYtOTA4OC1lZTMzODMzM2NmNjkiLCJpZCI6NTMsImV4cCI6MTc1ODIyNTc4NH0.u7icFwXtWGo7wWMkeo5stVr4CcrSxt7h2ebuQ7BTy2k";
//   // }
//
//   String? _refreshToken;
//   String? _accessToken;
//
//   Future<bool> logOut() async {
//     return true;
//   }
//
//   void setRefreshToken(String value) async {
//     _refreshToken = value;
//   }
//
//   String? getRefreshToken() {
//     return _refreshToken;
//   }
//
//   void delRefreshToken() async {
//     _refreshToken = null;
//   }
//
//
//
//   void setAccessToken(String value) async {
//     _accessToken = value;
//   }
//
//   String? getAccessToken() {
//     return _accessToken;
//   }
//
//   void delAccessToken() async {
//     _accessToken = null;
//   }
// }


import 'package:shared_preferences/shared_preferences.dart';

class DBService {
  static late final SharedPreferences _instance;

  static final ensure = DBService();

  Future<void> ensureInitialized() async {
    _instance = await SharedPreferences.getInstance();
  }

  bool isLoggedIn() {
    String token = getAccessToken();
    return token.isNotEmpty;
  }

  static Future<bool> logOut() async {
    var language = getLanguage();

    final res = await _instance.clear(); // Clear all data on database DB

    // in order save language after logout
    if (language != null) setLanguage(language);
    return res;
  }

  /// Language set [uz-UZ]
  static String? getLanguage() {
    var lang = _instance.getString(_StorageKeys.language);
    return lang;
  }

  /// Language get [uz-UZ]
  static Future<bool> setLanguage(String code) async {
    return await _instance.setString(_StorageKeys.language, code);
  }

  /// Access Token
  Future<bool> setAccessToken(String? value) async {
    if (value == null) return false;
    return await _instance.setString(_StorageKeys.accessToken, value);
  }

  String getAccessToken() {
    return _instance.getString(_StorageKeys.accessToken) ?? '';
  }

  Future<bool> delAccessToken() async {
    return await _instance.remove(_StorageKeys.accessToken);
  }

  /// Refresh Token - NEW METHODS
  Future<bool> setRefreshToken(String? value) async {
    if (value == null) return false;
    return await _instance.setString(_StorageKeys.refreshToken, value);
  }

  String getRefreshToken() {
    return _instance.getString(_StorageKeys.refreshToken) ?? '';
  }

  Future<bool> delRefreshToken() async {
    return await _instance.remove(_StorageKeys.refreshToken);
  }

  /// Clear all tokens - NEW METHOD
  Future<bool> clearTokens() async {
    bool accessCleared = await delAccessToken();
    bool refreshCleared = await delRefreshToken();
    return accessCleared && refreshCleared;
  }

  /// Client ID - NEW METHODS (if needed for refresh token API)
  Future<bool> setClientId(String? value) async {
    if (value == null) return false;
    return await _instance.setString(_StorageKeys.clientId, value);
  }

  String getClientId() {
    return "2927cba1-6b30-4a26-9088-ee338333cf69";
    // return _instance.getString(_StorageKeys.clientId) ?? '';
  }

  Future<bool> delClientId() async {
    return await _instance.remove(_StorageKeys.clientId);
  }
}

class _StorageKeys {
  static const language = 'language';
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const clientId = 'client_id';
}