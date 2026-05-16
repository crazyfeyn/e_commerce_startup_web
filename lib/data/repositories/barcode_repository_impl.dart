import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/data/models/barcode_product_model.dart';
import 'package:e_commerce_startup_web/domain/repositories/barcode_repository.dart';

class BarcodeRepositoryImpl extends BarcodeRepository {
  late final CancelTokenManager cancelTokenManager;

  BarcodeRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  @override
  Future<Either<String, int?>> createBarcodeProduct({
    required String barcode,
    required String nameEn,
    required List<String> ingredients,
    required bool isHalal,
  }) async {
    try {
      final api = NetworkService.apiCreateBarcodeProduct;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(
        api,
        cancelToken,
        NetworkService.paramsCreateBarcodeProduct(
          barcode: barcode,
          nameEn: nameEn,
          ingredients: ingredients,
          isHalal: isHalal,
        ),
      );
      if (response['success'] == true) {
        return Right(response['data']?['id']);
      }
      return Left('Failed to create barcode product');
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
  Future<Either<String, BarcodeProductModel>> lookupBarcodeProduct(
    String code,
  ) async {
    try {
      final api = NetworkService.apiLookupBarcodeProduct;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.get(
        api,
        cancelToken,
        NetworkService.paramsLookupBarcodeProduct(code),
      );
      if (response['success'] == true) {
        return Right(BarcodeProductModel.fromMap(response['data']));
      }
      return Left('Product not found');
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
