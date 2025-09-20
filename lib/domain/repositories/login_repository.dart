import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<String, bool>> login(String phone, String password);

  Future<Either<String, bool>> onRefreshToken(String clientId, String refreshToken);

  void dispose();
}