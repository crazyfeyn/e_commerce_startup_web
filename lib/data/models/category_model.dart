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

  TitleData({this.en});

  TitleData copyWith({String? en}) => TitleData(en: en ?? this.en);

  factory TitleData.fromMap(Map<String, dynamic> json) =>
      TitleData(en: json["en"]);

  Map<String, dynamic> toMap() => {"en": en};
}
