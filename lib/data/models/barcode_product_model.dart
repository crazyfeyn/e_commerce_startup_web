import 'package:e_commerce_startup_web/data/models/product_model.dart';

class BarcodeProductModel {
  final String? barcode;
  final bool? isHalal;
  final TitleData? name;
  final List<String>? ingredients;
  final String? halalStatus; // HALAL | HARAM | SUSPICIOUS | NOT_CERTIFIED
  final String? reason;

  BarcodeProductModel({
    this.barcode,
    this.isHalal,
    this.name,
    this.ingredients,
    this.halalStatus,
    this.reason,
  });

  factory BarcodeProductModel.fromMap(Map<String, dynamic> json) =>
      BarcodeProductModel(
        barcode: json['barcode'],
        isHalal: json['isHalal'],
        name: json['name'] == null ? null : TitleData.fromMap(json['name']),
        ingredients: json['ingredients'] == null
            ? []
            : List<String>.from(json['ingredients']),
        halalStatus: json['halalStatus'],
        reason: json['reason'],
      );
}
