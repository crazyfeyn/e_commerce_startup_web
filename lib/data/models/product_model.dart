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
  final TitleData? titleData;
  final List<String>? images;
  final String? description;
  final String? brand;
  final double? amount;
  final String? currency;
  final double? price;
  final int? measurementId;
  final int? totalSoldAmount;

  ProductModel({
    this.id,
    this.categoryId,
    this.titleData,
    this.images,
    this.description,
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
    TitleData? titleData,
    List<String>? images,
    String? description,
    String? brand,
    double? amount,
    String? currency,
    double? price,
    int? measurementId,
    int? totalSoldAmount,
  }) => ProductModel(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    titleData: titleData ?? this.titleData,
    images: images ?? this.images,
    description: description ?? this.description,
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
    titleData: json["titleData"] == null
        ? null
        : TitleData.fromMap(json["titleData"]),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
    description: json["description"],
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
    "titleData": titleData?.toMap(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "description": description,
    "brand": brand,
    "amount": amount,
    "currency": currency,
    "price": price,
    "measurementId": measurementId,
    "totalSoldAmount": totalSoldAmount,
  };

  Map<String, dynamic> toCreate() => {
    "categoryId": categoryId,
    "titleData": titleData?.toMap(),
    "description": description,
    "brand": brand,
    "amount": amount,
    "currency": currency,
    "price": price,
    "measurementId": measurementId,
    "totalSoldAmount": totalSoldAmount,
  };

  Map<String, dynamic> toEdit() => {
    "id": id,
    "categoryId": categoryId,
    "titleData": titleData?.toMap(),
    "description": description,
    "brand": brand,
    "amount": amount,
    "currency": currency,
    "price": price,
    "measurementId": measurementId,
    "totalSoldAmount": totalSoldAmount,
  };
}

class TitleData {
  final String? en;
  final String? kor;
  final String? uz;

  TitleData({this.en, this.kor, this.uz});

  TitleData copyWith({String? en, String? kor, String? uz}) =>
      TitleData(en: en ?? this.en, kor: kor ?? this.kor, uz: uz ?? this.uz);

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

  factory TitleData.fromMap(Map<String, dynamic> json) =>
      TitleData(en: json["en"], kor: json["kor"], uz: json["uz"]);

  Map<String, dynamic> toMap() => {"en": en, "kor": kor, "uz": uz};
}
