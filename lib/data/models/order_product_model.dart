import 'package:e_commerce_startup_web/data/models/product_model.dart';

/// Simplified product model used in order lists (admin and client).
/// Matches the structure returned by /api/v1/order/get-all and /api/v1/admin/order/get-all.
class OrderProductModel {
  final int orderId;
  final int productId;
  final double price;
  final String currency;
  final int amount;
  final int measurementId;
  final String? title;
  final TitleData? titleData;

  OrderProductModel({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.currency,
    required this.amount,
    required this.measurementId,
    this.title,
    this.titleData,
  });

  /// Returns the best available display name for the product.
  String displayName(String langCode) {
    final localized = titleData?.getLocalized(langCode);
    if (localized != null && localized.isNotEmpty) return localized;
    if (title != null && title!.isNotEmpty) return title!;
    return '#$productId';
  }

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      orderId: json['orderId'] ?? 0,
      productId: json['productId'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      amount: json['amount'] ?? 0,
      measurementId: json['measurementId'] ?? 0,
      title: json['title'] as String?,
      titleData: json['titleData'] != null
          ? TitleData.fromMap(json['titleData'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'productId': productId,
      'price': price,
      'currency': currency,
      'amount': amount,
      'measurementId': measurementId,
      'title': title,
      'titleData': titleData?.toMap(),
    };
  }
}
