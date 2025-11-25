import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/order_model.dart';
import 'package:e_commerce_startup_web/data/repositories/order_repository_impl.dart';
import 'package:flutter/material.dart';

class OrdersViewmodel extends ChangeNotifier {
  final _repository = OrdersRepositoryImpl();

  OrdersViewmodel() {
    fetchOrders();
  }

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.inProgress;
  List<OrderModel> orders = [];
  final Set<int> _confirmingOrders = {};

  bool isOrderConfirming(int orderId) => _confirmingOrders.contains(orderId);

  Future<void> fetchOrders({bool showLoader = true}) async {
    if (showLoader) {
      formzStatus = FormzSubmissionStatus.inProgress;
      notifyListeners();
    }
    final result = await _repository.fetchOrders();
    result.fold(
      (_) => formzStatus = FormzSubmissionStatus.failure,
      (data) {
        orders = data;
        formzStatus = FormzSubmissionStatus.success;
      },
    );
    notifyListeners();
  }

  Future<bool> confirmOrder(int orderId) async {
    if (_confirmingOrders.contains(orderId)) return false;
    _confirmingOrders.add(orderId);
    notifyListeners();

    final result = await _repository.confirmOrder(orderId);
    final isSuccess = result.getOrElse(() => false);

    if (isSuccess) {
      await fetchOrders(showLoader: false);
    }

    _confirmingOrders.remove(orderId);
    notifyListeners();

    return isSuccess;
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
