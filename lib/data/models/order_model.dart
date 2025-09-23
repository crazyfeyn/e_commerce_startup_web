import 'package:e_commerce_startup_web/data/models/product_model.dart';

class OrderModel {
  final int orderId;
  final double totalPrice;
  final String currency;
  final String orderStatus;
  final String paymentMethod;
  final String imageIdentity;
  final String receiverAddress;
  final String receiverPhone;
  final String receiverName;
  final List<ProductModel> products;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.totalPrice,
    required this.currency,
    required this.orderStatus,
    required this.paymentMethod,
    required this.imageIdentity,
    required this.receiverAddress,
    required this.receiverPhone,
    required this.receiverName,
    required this.products,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      imageIdentity: json['imageIdentity'] ?? '',
      receiverAddress: json['receiverAddress'] ?? '',
      receiverPhone: json['receiverPhone'] ?? '',
      receiverName: json['receiverName'] ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromMap(e))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'totalPrice': totalPrice,
      'currency': currency,
      'orderStatus': orderStatus,
      'paymentMethod': paymentMethod,
      'imageIdentity': imageIdentity,
      'receiverAddress': receiverAddress,
      'receiverPhone': receiverPhone,
      'receiverName': receiverName,
      'products': products.map((e) => e.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
