import 'package:e_commerce_startup_web/data/models/order_model.dart';
import 'package:e_commerce_startup_web/data/models/product_model.dart';

class Sample {
  static final List<OrderModel> sampleOrders = [
    OrderModel(
      orderId: 1001,
      receiverName: "John Doe",
      receiverPhone: "+998901234567",
      receiverAddress: "Tashkent, Uzbekistan",
      products: [
        ProductModel(
          id: 1,
          categoryId: 101,
          titleData: TitleData(
            en: "iPhone 15 Pro",
            kor: "아이폰 15 프로",
            uz: "iPhone 15 Pro",
          ),
          price: 14500000,
          currency: "UZS",
          images: ["https://via.placeholder.com/150"],
          // Added for testing
          description: "Latest iPhone 15 Pro",
          brand: "Apple",
        ),
        ProductModel(
          id: 2,
          categoryId: 102,
          titleData: TitleData(
            en: "AirPods Pro 2",
            kor: "에어팟 프로 2",
            uz: "AirPods Pro 2",
          ),
          price: 2500000,
          currency: "UZS",
          images: ["https://via.placeholder.com/100"],
          description: "Noise-cancelling AirPods",
          brand: "Apple",
        ),
        ProductModel(
          id: 2,
          categoryId: 102,
          titleData: TitleData(
            en: "AirPods Pro 2",
            kor: "에어팟 프로 2",
            uz: "AirPods Pro 2",
          ),
          price: 2500000,
          currency: "UZS",
          images: ["https://via.placeholder.com/100"],
          description: "Noise-cancelling AirPods",
          brand: "Apple",
        ),
        ProductModel(
          id: 2,
          categoryId: 102,
          titleData: TitleData(
            en: "AirPods Pro 2",
            kor: "에어팟 프로 2",
            uz: "AirPods Pro 2",
          ),
          price: 2500000,
          currency: "UZS",
          images: ["https://via.placeholder.com/100"],
          description: "Noise-cancelling AirPods",
          brand: "Apple",
        ),
      ],
      totalPrice: 17000000,
      currency: "UZS",
      orderStatus: "pending",
      paymentMethod: "card",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      imageIdentity: '',
    ),
    OrderModel(
      orderId: 1002,
      receiverName: "Jane Smith",
      receiverPhone: "+998901112233",
      receiverAddress: "Samarkand, Uzbekistan",
      products: [
        ProductModel(
          id: 3,
          categoryId: 103,
          titleData: TitleData(
            en: "Samsung Galaxy S24",
            kor: "삼성 갤럭시 S24",
            uz: "Samsung Galaxy S24",
          ),
          price: 11000000,
          currency: "UZS",
          images: ["https://via.placeholder.com/120"],
          description: "Samsung flagship model",
          brand: "Samsung",
        ),
      ],
      totalPrice: 11000000,
      currency: "UZS",
      orderStatus: "confirmed",
      paymentMethod: "cash",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      imageIdentity: '',
    ),
  ];
}
