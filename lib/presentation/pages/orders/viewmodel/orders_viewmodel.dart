import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/order_model.dart';
import 'package:e_commerce_startup_web/data/repositories/order_repository_impl.dart';
import 'package:flutter/material.dart';

class OrdersViewmodel extends ChangeNotifier {
  final _repository = OrdersRepositoryImpl();

  OrdersViewmodel() {
    fetchCategories();
  }

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.inProgress;
  List<OrderModel> orders = [];

  Future<void> fetchCategories() async {
    final result = await _repository.fetchOrders();
    if (result.isRight()) {
      orders = result.getOrElse(() => throw Exception("Unexpected error"));
      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
