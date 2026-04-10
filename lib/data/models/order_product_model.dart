/// Simplified product model used in order lists (admin and client).
/// Matches the structure returned by /api/v1/order/get-all and /api/v1/admin/order/get-all.
class OrderProductModel {
  final int orderId;
  final int productId;
  final double price;
  final String currency;
  final int amount;
  final int measurementId;

  OrderProductModel({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.currency,
    required this.amount,
    required this.measurementId,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      orderId: json['orderId'] ?? 0,
      productId: json['productId'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      amount: json['amount'] ?? 0,
      measurementId: json['measurementId'] ?? 0,
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
    };
  }
}
