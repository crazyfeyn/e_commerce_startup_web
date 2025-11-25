import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/data/models/order_model.dart';
import 'package:e_commerce_startup_web/domain/repositories/orders_repository.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  late final CancelTokenManager cancelTokenManager;

  OrdersRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  @override
  Future<Either<String, List<OrderModel>>> fetchOrders({
    int page = 0,
    int size = 100,
  }) async {
    try {
      final api = NetworkService.apiFetchOrders;
      final cancelToken = cancelTokenManager.getToken(api);

      final queryParams = {'page': page.toString(), 'size': size.toString()};

      final response = await NetworkService.get(api, cancelToken, queryParams);
      final List<OrderModel> result = (response["data"]["list"] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      return Right(result);
    } on NetworkException catch (e) {
      if (e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> confirmOrder(int orderId) async {
    try {
      final api = NetworkService.apiConfirmOrder;
      final cancelToken = cancelTokenManager.getToken("$api-$orderId");
      final response = await NetworkService.put(
        api,
        cancelToken,
        null,
        {"orderId": orderId},
      );
      final success = response?["success"] == true;
      if (success) {
        return const Right(true);
      } else {
        final message = response?["error"]?["message"] ??
            LocaleKeys.confirm_order_failed.tr();
        GlobalSnackBar.showError(message);
        return Left(message);
      }
    } on NetworkException catch (e) {
      if (e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  void dispose() => cancelTokenManager.cancelAll();
}
