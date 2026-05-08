// Replace your existing TitleData class with this:

class TitleData {
  final Map<String, String> _data;

  TitleData(this._data);

  factory TitleData.fromMap(Map<String, dynamic>? map) {
    if (map == null) return TitleData({});
    return TitleData(
      map.map((key, value) => MapEntry(key, value?.toString() ?? '')),
    );
  }

  // Language code mapping from Flutter locale to backend key
  static const Map<String, String> _langMap = {
    'ko': 'kor',
    'en': 'en',
    'uz': 'uz',
    'zh': 'zh_cn',
    'zh_Hant': 'zh_tw',
    'vi': 'vi',
    'ja': 'ja',
    'th': 'th',
    'ru': 'ru',
    'mn': 'mn',
    'id': 'id',
    'fil': 'fil',
    'ne': 'ne',
    'km': 'km',
    'my': 'my',
    'hi': 'hi',
    'bn': 'bn',
    'ar': 'ar',
    'fr': 'fr',
    'pt': 'pt',
    'es': 'es',
    'tr': 'tr',
    'ms': 'ms',
    'de': 'de',
    'it': 'it',
    'ta': 'ta',
    'si': 'si',
    'kk': 'kk',
    'ky': 'ky',
    'uk': 'uk',
  };

  String getTitle(String langCode) {
    // 1. Try exact match
    if (_data.containsKey(langCode) && _data[langCode]!.isNotEmpty) {
      return _data[langCode]!;
    }

    // 2. Try mapped key
    final mapped = _langMap[langCode];
    if (mapped != null &&
        _data.containsKey(mapped) &&
        _data[mapped]!.isNotEmpty) {
      return _data[mapped]!;
    }

    // 3. Fallback to English
    return _data['en'] ??
        _data.values.firstWhere((v) => v.isNotEmpty, orElse: () => '');
  }

  Map<String, dynamic> toMap() => _data;
}
