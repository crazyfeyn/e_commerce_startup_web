import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/data/models/measurement_model.dart';
import 'package:e_commerce_startup_web/data/models/product_model.dart';
import 'package:e_commerce_startup_web/data/models/upload_image_model.dart';
import 'package:e_commerce_startup_web/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  late final CancelTokenManager cancelTokenManager;

  ProductRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  @override
  Future<Either<String, List<ProductModel>>> fetchProducts() async {
    try {
      final api = NetworkService.apiFetchProducts;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.get(api, cancelToken);
      final result = response["data"]["list"].map<ProductModel>((e) => ProductModel.fromMap(e)).toList();
      return Right(result);
    } on NetworkException catch(e) {
      if(e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MeasurementModel>>> fetchMeasurements() async {
    try {
      final api = NetworkService.apiFetchMeasurement;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.get(api, cancelToken);
      final result = response["data"]["list"].map<MeasurementModel>((e) => MeasurementModel.fromMap(e)).toList();
      return Right(result);
    } on NetworkException catch(e) {
      if(e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> createProduct(ProductModel product) async {
    try {
      final api = NetworkService.apiCreateProduct;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(api, cancelToken, product.toCreate());
      final result = response["success"];
      return Right(result);
    } on NetworkException catch(e) {
      if(e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> editProduct(ProductModel product) async {
    try {
      final api = NetworkService.apiEditProduct;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.put(api, cancelToken, product.toEdit(), NetworkService.paramsEditProduct(product.id!));
      final result = response["success"];
      return Right(result);
    } on NetworkException catch(e) {
      if(e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> deleteProduct(int productId) async {
    try {
      final api = NetworkService.apiDeleteProduct;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.delete(api, cancelToken, NetworkService.paramsEditProduct(productId));
      final result = response["success"];
      return Right(result);
    } on NetworkException catch(e) {
      if(e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  void dispose() => cancelTokenManager.cancelAll();

  @override
  Future<Either<String, bool>> uploadImage(int productId, List<UploadImageModel> files) async {
    try {
      final api = NetworkService.apiUploadImageProduct;
      final cancelToken = cancelTokenManager.getToken(api);

      final formData = FormData();

      for (final file in files) {
        formData.files.add(
          MapEntry(
            "files",
            MultipartFile.fromBytes(
              file.file,
              filename: file.name,
              contentType: DioMediaType("image", "png"),
            ),
          ),
        );
      }

      final response = await NetworkService.post(
        api,
        cancelToken,
        formData,
        NetworkService.paramsEditProduct(productId),
      );

      final result = response["success"];
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

}