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
  String? lastError;
  final Set<int> _confirmingOrders = {};
  final Set<int> _editingOrders = {};

  bool isOrderConfirming(int orderId) => _confirmingOrders.contains(orderId);
  bool isOrderEditing(int orderId) => _editingOrders.contains(orderId);

  Future<void> fetchOrders({bool showLoader = true}) async {
    if (showLoader) {
      formzStatus = FormzSubmissionStatus.inProgress;
      notifyListeners();
    }
    final result = await _repository.fetchOrders();
    result.fold(
      (error) {
        lastError = error;
        formzStatus = FormzSubmissionStatus.failure;
      },
      (data) {
        lastError = null;
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

  Future<bool> editOrderStatus(int orderId, String status) async {
    if (_editingOrders.contains(orderId)) return false;
    _editingOrders.add(orderId);
    notifyListeners();

    final result = await _repository.editOrderStatus(orderId, status);
    final isSuccess = result.getOrElse(() => false);

    if (isSuccess) {
      await fetchOrders(showLoader: false);
    }

    _editingOrders.remove(orderId);
    notifyListeners();

    return isSuccess;
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
