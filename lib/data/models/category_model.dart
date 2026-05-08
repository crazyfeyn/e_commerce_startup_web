// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromMap(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromMap(String str) =>
    CategoryModel.fromMap(json.decode(str));

String categoryModelToMap(CategoryModel data) => json.encode(data.toMap());

class CategoryModel {
  final int? id;
  final TitleData? titleData;
  final String? description; // This is the prompt for Anthropic
  final String? imageIdentity;

  CategoryModel({
    this.id,
    this.titleData,
    this.description,
    this.imageIdentity,
  });

  CategoryModel copyWith({
    int? id,
    TitleData? titleData,
    String? description,
    String? imageIdentity,
  }) => CategoryModel(
    id: id ?? this.id,
    titleData: titleData ?? this.titleData,
    description: description ?? this.description,
    imageIdentity: imageIdentity ?? this.imageIdentity,
  );

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    titleData: json["titleData"] == null
        ? null
        : TitleData.fromMap(json["titleData"]),
    description: json["description"],
    imageIdentity: json['imageIdentity'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "titleData": titleData?.toMap(),
    "description": description,
    'imageIdentity': imageIdentity,
  };
}

class TitleData {
  final String? en;
  final String? kor;
  final String? uz;
  // Backend will add more languages via Anthropic

  TitleData({this.en, this.kor, this.uz});

  String? getTitle(String langCode) {
    switch (langCode) {
      case "uz":
        return uz ?? en; // Fallback to English if Uzbek not available
      case "en":
        return en;
      default: // ko, etc.
        return kor ?? en; // Fallback to English
    }
  }

  TitleData copyWith({String? en, String? kor, String? uz}) =>
      TitleData(en: en ?? this.en, kor: kor ?? this.kor, uz: uz ?? this.uz);

  factory TitleData.fromMap(Map<String, dynamic> json) =>
      TitleData(en: json["en"], kor: json["kor"], uz: json["uz"]);

  Map<String, dynamic> toMap() => {"en": en, "kor": kor, "uz": uz};

  /// Create TitleData with only English (backend will translate)
  factory TitleData.englishOnly(String title) => TitleData(en: title);
}
