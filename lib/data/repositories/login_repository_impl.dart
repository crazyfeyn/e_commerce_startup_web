import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  late final CancelTokenManager cancelTokenManager;

  LoginRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  @override
  Future<Either<String, bool>> login(String phone, String password) async {
    try {
      final api = NetworkService.apiLogin;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(api, cancelToken, NetworkService.paramsLogin(phone, password));

      DBService.ensure.setRefreshToken(response["data"]["refreshToken"]);
      DBService.ensure.setAccessToken(response["data"]["accessToken"]);
      DBService.ensure.setClientId(response["data"]["clientId"]);
      final result = response['success'];
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
  Future<Either<String, bool>> onRefreshToken(String clientId, String refreshToken) async {
    try {
      final api = NetworkService.apiRefreshToken;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(api, cancelToken, NetworkService.paramsRefreshToken(clientId, refreshToken));

      DBService.ensure.setRefreshToken(response["data"]["refreshToken"]);
      DBService.ensure.setAccessToken(response["data"]["accessToken"]);
      DBService.ensure.setClientId(response["data"]["clientId"]);
      final result = response['success'];
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

}