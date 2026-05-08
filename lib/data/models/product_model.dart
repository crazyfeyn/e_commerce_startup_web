// To parse this JSON data, do
//
//     final productModel = productModelFromMap(jsonString);

import 'dart:convert';

ProductModel productModelFromMap(String str) =>
    ProductModel.fromMap(json.decode(str));

String productModelToMap(ProductModel data) => json.encode(data.toMap());

class ProductModel {
  final int? id;
  final int? categoryId;
  final String? title;
  final TitleData? titleData;
  final List<String>? images;
  final String? description;
  final TitleData? descriptionData;
  final String? brand;
  final double? amount;
  final String? currency;
  final double? price;
  final int? measurementId;
  final int? totalSoldAmount;

  ProductModel({
    this.id,
    this.categoryId,
    this.title,
    this.titleData,
    this.images,
    this.description,
    this.descriptionData,
    this.brand,
    this.amount,
    this.currency,
    this.price,
    this.measurementId,
    this.totalSoldAmount,
  });

  ProductModel copyWith({
    int? id,
    int? categoryId,
    String? title,
    TitleData? titleData,
    List<String>? images,
    String? description,
    TitleData? descriptionData,
    String? brand,
    double? amount,
    String? currency,
    double? price,
    int? measurementId,
    int? totalSoldAmount,
  }) => ProductModel(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    title: title ?? this.title,
    titleData: titleData ?? this.titleData,
    images: images ?? this.images,
    description: description ?? this.description,
    descriptionData: descriptionData ?? this.descriptionData,
    brand: brand ?? this.brand,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    price: price ?? this.price,
    measurementId: measurementId ?? this.measurementId,
    totalSoldAmount: totalSoldAmount ?? this.totalSoldAmount,
  );

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    categoryId: json["categoryId"],
    title: json["title"],
    titleData: json["titleData"] == null
        ? null
        : TitleData.fromMap(json["titleData"]),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
    description: json["description"],
    descriptionData: json["descriptionData"] == null
        ? null
        : TitleData.fromMap(json["descriptionData"]),
    brand: json["brand"],
    amount: double.tryParse(json["amount"]?.toString() ?? ""),
    currency: json["currency"],
    price: double.tryParse(json["price"]?.toString() ?? ""),
    measurementId: json["measurementId"],
    totalSoldAmount: json["totalSoldAmount"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "categoryId": categoryId,
    "title": title,
    "titleData": titleData?.toMap(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "description": description,
    "descriptionData": descriptionData?.toMap(),
    "brand": brand,
    "amount": amount,
    "currency": currency,
    "price": price,
    "measurementId": measurementId,
    "totalSoldAmount": totalSoldAmount,
  };

  /// Sent to POST /api/v1/admin/product/create
  /// Admin provides English title + description only.
  /// Backend calls Anthropic to auto-translate into all 29 languages.
  Map<String, dynamic> toCreate() => {
    "title": titleData?.getLocalized("en") ?? title ?? "",
    "titleData": {"en": titleData?.getLocalized("en") ?? title ?? ""},
    "description": description ?? "",
    "categoryId": categoryId,
    "brand": brand ?? "",
    "amount": amount,
    "currency": currency ?? "KRW",
    "price": price,
    "measurementId": measurementId,
  };

  /// Sent to PUT /api/v1/admin/product/edit
  /// Same shape as create — backend re-translates on edit too.
  Map<String, dynamic> toEdit() => {
    "title": titleData?.getLocalized("en") ?? title ?? "",
    "titleData": {"en": titleData?.getLocalized("en") ?? title ?? ""},
    "description": description ?? "",
    "categoryId": categoryId,
    "brand": brand ?? "",
    "amount": amount,
    "currency": currency ?? "KRW",
    "price": price,
    "measurementId": measurementId,
  };
}

class TitleData {
  /// Internal store for all language translations returned from the backend.
  final Map<String, String> _data;

  TitleData({Map<String, String>? data}) : _data = data ?? {};

  /// Flutter locale code → backend language key mapping.
  static const Map<String, String> _localeToKey = {
    'ko': 'kor',
    'en': 'en',
    'uz': 'uz',
    'zh': 'zh_cn',
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

  /// Returns the localized string for [langCode] with English fallback.
  ///
  /// Lookup order:
  ///   1. Exact key match (e.g. "en", "ru")
  ///   2. Mapped key (e.g. "ko" → "kor")
  ///   3. English fallback
  ///   4. First non-empty value in the map
  String? getLocalized(String langCode) {
    // 1. Exact match
    final direct = _data[langCode];
    if (direct != null && direct.isNotEmpty) return direct;

    // 2. Mapped key
    final mapped = _localeToKey[langCode];
    if (mapped != null) {
      final via = _data[mapped];
      if (via != null && via.isNotEmpty) return via;
    }

    // 3. English fallback
    final en = _data['en'];
    if (en != null && en.isNotEmpty) return en;

    // 4. First non-empty
    return _data.values.firstWhere((v) => v.isNotEmpty, orElse: () => '');
  }

  /// Convenience getter — used throughout the UI for display.
  String? getTitle(String langCode) => getLocalized(langCode);

  /// Parses a backend response object that may have any of the 29 language keys.
  factory TitleData.fromMap(Map<String, dynamic> json) {
    final data = <String, String>{};
    for (final entry in json.entries) {
      if (entry.value != null) {
        data[entry.key] = entry.value.toString();
      }
    }
    return TitleData(data: data);
  }

  /// Used when sending data to the backend.
  /// Only serialises keys that are present in [_data].
  Map<String, dynamic> toMap() => Map<String, dynamic>.from(_data);

  /// Shorthand to build a TitleData with only the English key set.
  /// Used in the dialog when creating / editing a product.
  factory TitleData.englishOnly(String title) => TitleData(data: {'en': title});

  // ── Legacy getters kept for any remaining read-only references ────────────
  String? get en => _data['en'];
  String? get kor => _data['kor'];
  String? get uz => _data['uz'];
}
