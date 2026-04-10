import 'order_product_model.dart';

class OrderModel {
  final int orderId;
  final double totalPrice;
  final String currency;
  final String orderStatus;
  final String?
  paymentMethod; // nullable – not always returned by admin endpoint
  final String? imageIdentity; // nullable
  final String receiverAddress;
  final String receiverPhone;
  final String receiverName;
  final List<OrderProductModel> products; // changed from List<ProductModel>
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.totalPrice,
    required this.currency,
    required this.orderStatus,
    this.paymentMethod,
    this.imageIdentity,
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
      paymentMethod: json['paymentMethod'], // may be null or empty string
      imageIdentity: json['imageIdentity'],
      receiverAddress: json['receiverAddress'] ?? '',
      receiverPhone: json['receiverPhone'] ?? '',
      receiverName: json['receiverName'] ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => OrderProductModel.fromJson(e))
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
      'products': products.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
