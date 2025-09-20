import 'package:dio/dio.dart';

class CancelTokenManager {
  final Map<String, CancelToken> _tokens = {};

  /// Token yaratish va olish
  CancelToken getToken(String key) {
    return _tokens.putIfAbsent(key, () => CancelToken());
  }

  /// Tokenni bekor qilish
  void cancel(String key) {
    if (_tokens.containsKey(key)) {
      _tokens[key]?.cancel("Cancelled by user");
      _tokens.remove(key);
    }
  }

  /// Hammasini tozalash (masalan, dispose paytida)
  void cancelAll() {
    for (var token in _tokens.values) {
      token.cancel("Cancelled all");
    }
    _tokens.clear();
  }

  /// Token mavjudligini tekshirish
  bool contains(String key) => _tokens.containsKey(key);
}
