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
  final String? description;
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

  TitleData({this.en, this.kor, this.uz});

  String? getTitle(String langCode) {
    switch (langCode) {
      case "uz":
        return uz;
      case "en":
        return en;
      default:
        return kor;
    }
  }

  TitleData copyWith({String? en, String? kor, String? uz}) =>
      TitleData(en: en ?? this.en, kor: kor ?? this.kor, uz: uz ?? this.uz);

  factory TitleData.fromMap(Map<String, dynamic> json) =>
      TitleData(en: json["en"], kor: json["kor"], uz: json["uz"]);

  Map<String, dynamic> toMap() => {"en": en, "kor": kor, "uz": uz};
}
