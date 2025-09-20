import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart';
import 'package:e_commerce_startup_web/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  late final CancelTokenManager cancelTokenManager;

  CategoryRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  @override
  Future<Either<String, List<CategoryModel>>> fetchCategories() async {
    try {
      final api = NetworkService.apiFetchCategories;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.get(api, cancelToken);
      final result = response["data"]["list"].map<CategoryModel>((e) => CategoryModel.fromMap(e)).toList();
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
  Future<Either<String, bool>> createCategory(Map<String, dynamic> title, String prompt) async {
    try {
      final api = NetworkService.apiCreateCategory;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(api, cancelToken, NetworkService.paramsCategory(title, prompt));
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
  Future<Either<String, bool>> editCategory(int categoryId, Map<String, dynamic> title, String prompt) async {
    try {
      final api = NetworkService.apiEditCategory;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.put(api, cancelToken, NetworkService.paramsCategory(title, prompt), NetworkService.paramsEditCategory(categoryId));
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
  Future<Either<String, bool>> deleteCategory(int categoryId) async {
    try {
      final api = NetworkService.apiDeleteCategory;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.delete(api, cancelToken, NetworkService.paramsEditCategory(categoryId));
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
}