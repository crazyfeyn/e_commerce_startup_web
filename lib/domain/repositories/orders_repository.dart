import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/data/models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<String, List<OrderModel>>> fetchOrders({
    int page = 0,
    int size = 100,
  });
  void dispose();
}
