import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/core/utils/jwt_utils.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/domain/repositories/login_repository.dart';
import 'package:flutter/material.dart';

class LoginRepositoryImpl extends LoginRepository {
  late final CancelTokenManager cancelTokenManager;

  LoginRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  String _maskToken(String? token) {
    if (token == null) return 'null';
    if (token.isEmpty) return '';
    final start = token.length >= 8 ? token.substring(0, 8) : token;
    final end = token.length >= 8 ? token.substring(token.length - 8) : '';
    return end.isEmpty ? '$start...' : '$start...$end';
  }

  @override
  Future<Either<String, bool>> login(String phone, String password) async {
    try {
      final api = NetworkService.apiLogin;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(
        api,
        cancelToken,
        NetworkService.paramsLogin(phone, password),
      );
      final refreshToken = response["data"]["refreshToken"];
      final accessToken = response["data"]["accessToken"];
      await DBService.ensure.setRefreshToken(refreshToken);
      await DBService.ensure.setAccessToken(accessToken);

      // Backend doesn't always return clientId as a top-level field; it's present in JWT payload.
      final clientId =
          JwtUtils.extractClientId(accessToken ?? "") ??
          JwtUtils.extractClientId(refreshToken ?? "") ??
          response["data"]["clientId"];
      await DBService.ensure.setClientId(clientId);

      debugPrint(
        '[DBService] login saved: accessToken(${accessToken.length})=${_maskToken(accessToken)}, refreshToken(${refreshToken.length})=${_maskToken(refreshToken)}, clientId=${clientId.isEmpty ? "(empty)" : clientId}',
      );

      final result = response['success'];
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
  void dispose() => cancelTokenManager.cancelAll();

  @override
  Future<Either<String, bool>> registerAdmin({
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final api = NetworkService.apiAdminRegister;
      final cancelToken = cancelTokenManager.getToken(api);

      final response = await NetworkService.post(
        api,
        cancelToken,
        NetworkService.paramsAdminRegister(
          firstname: firstname.trim(),
          lastname: lastname.trim(),
          phoneNumber: phoneNumber.trim(),
          password: password,
        ),
      );

      final result = response['success'] == true;
      if (!result) {
        final errMsg = response["error"]?["message"]?.toString();
        if (errMsg != null && errMsg.isNotEmpty) {
          GlobalSnackBar.showError(errMsg);
        }
      }
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
  Future<Either<String, bool>> onRefreshToken(
    String clientId,
    String refreshToken,
  ) async {
    try {
      final api = NetworkService.apiRefreshToken;
      final cancelToken = cancelTokenManager.getToken(api);
      final response = await NetworkService.post(
        api,
        cancelToken,
        NetworkService.paramsRefreshToken(clientId, refreshToken),
      );

      final newRefreshToken = response["data"]["refreshToken"];
      final newAccessToken = response["data"]["accessToken"];
      await DBService.ensure.setRefreshToken(newRefreshToken);
      await DBService.ensure.setAccessToken(newAccessToken);

      final newClientId =
          JwtUtils.extractClientId(newAccessToken ?? "") ??
          JwtUtils.extractClientId(newRefreshToken ?? "") ??
          response["data"]["clientId"];
      await DBService.ensure.setClientId(newClientId);

      debugPrint(
        '[DBService] refresh saved: accessToken(${newAccessToken.length})=${_maskToken(newAccessToken)}, refreshToken(${newRefreshToken.length})=${_maskToken(newRefreshToken)}, clientId=${newClientId.isEmpty ? "(empty)" : newClientId}',
      );

      final result = response['success'];
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
