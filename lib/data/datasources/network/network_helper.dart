import 'package:dio/dio.dart';
import 'package:e_commerce_startup_web/core/services/lang_service.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/repositories/login_repository_impl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

class NetworkInterceptor extends Interceptor {
  final Dio dio;

  NetworkInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final langCode = LangService.currentLocale;
    final accessToken = DBService.ensure.getAccessToken();
    if (accessToken.isEmpty) {
      options.headers["Authorization"] = "Bearer $accessToken";
      options.headers["X-Request-UUID"] =  Uuid().v4();
      options.headers["X-Client-Lang"] = langCode;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final repository = LoginRepositoryImpl();

    // Don't handle refresh logic for auth endpoints
    if (err.requestOptions.path.contains("auth")) {
      return handler.next(err);
    }

    // Check if error is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      final clientId = DBService.ensure.getClientId();
      final refreshToken = DBService.ensure.getRefreshToken();
      final result = await repository.onRefreshToken(clientId, refreshToken);
      if(result.isRight()) {
        final res = result.getOrElse(() => throw Exception("Unexpected error"));
        if(res) {
          final newHeaders = Map<String, dynamic>.from(err.requestOptions.headers);
          newHeaders['Authorization'] = 'Bearer ${DBService.ensure.getAccessToken()}';
          final clonedRequest = err.requestOptions.copyWith(headers: newHeaders);
          final response = await dio.fetch(clonedRequest);
          return handler.resolve(response);
        } else {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }
}

enum NetworkExceptionType {
  noInternet,
  timeout,
  serverError,
  cancelled,
  formatError,
  badCertificate,
  unknown,
}

class NetworkException implements Exception {
  final int? code;
  final int? httpStatus;
  final String message;
  final NetworkExceptionType type;

  NetworkException(this.message, this.type, {this.code, this.httpStatus});

  factory NetworkException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          LocaleKeys.timeout_message.tr(),
          NetworkExceptionType.timeout,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          LocaleKeys.check_internet_connection.tr(),
          NetworkExceptionType.noInternet,
        );
      case DioExceptionType.badResponse:
        final res = e.response?.data["error"];
        return NetworkException(
          code: res?["code"],
          httpStatus: res?["httpStatus"],
          res?["message"] ?? "",
          NetworkExceptionType.serverError,
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          LocaleKeys.bad_certificate_message.tr(),
          NetworkExceptionType.badCertificate,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          e.message ?? "",
          NetworkExceptionType.cancelled,
        );
      default:
        return NetworkException(
          LocaleKeys.dio_unknown_message.tr(args: [e.message ?? ""]),
          NetworkExceptionType.unknown,
        );
    }
  }

  @override
  String toString() => message;
}
