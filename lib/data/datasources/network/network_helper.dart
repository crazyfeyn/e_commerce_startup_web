import 'package:dio/dio.dart';
import 'package:e_commerce_startup_web/core/services/lang_service.dart';
import 'package:e_commerce_startup_web/core/utils/jwt_utils.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/repositories/login_repository_impl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

class QueueItem {
  final DioException err;
  final ErrorInterceptorHandler handler;
  final Function(String) completion;

  QueueItem({
    required this.err,
    required this.handler,
    required this.completion,
  });
}

class NetworkInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<QueueItem> _queue = [];

  NetworkInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final langCode = LangService.currentLocale;
    final accessToken = DBService.ensure.getAccessToken();

    if (accessToken.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }

    // Add required headers from Swagger
    options.headers["X-Request-UUID"] = Uuid().v4();
    options.headers["X-Client-Lang"] = langCode;
    options.headers["X-Device-Type"] = "Web"; // Added this required header

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Don't handle refresh logic for auth endpoints
    if (err.requestOptions.path.contains("auth")) {
      return handler.next(err);
    }

    // Guard: if this request already went through a retry, don't loop again
    if (err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      // Queue this request while refreshing
      if (_isRefreshing) {
        _queue.add(
          QueueItem(
            err: err,
            handler: handler,
            completion: (newToken) async {
              final retryOptions = _cloneRequestWithNewToken(
                err.requestOptions,
                newToken,
              );
              try {
                final response = await dio.fetch(retryOptions);
                handler.resolve(response);
              } catch (e) {
                handler.reject(e as DioException);
              }
            },
          ),
        );
        return;
      }

      _isRefreshing = true;

      final refreshToken = DBService.ensure.getRefreshToken();
      final storedClientId = DBService.ensure.getClientId();
      final clientId = storedClientId.isNotEmpty
          ? storedClientId
          : (JwtUtils.extractClientId(refreshToken) ?? "");

      if (clientId.isEmpty || refreshToken.isEmpty) {
        _isRefreshing = false;
        return handler.next(err);
      }

      final repository = LoginRepositoryImpl();
      final result = await repository.onRefreshToken(clientId, refreshToken);

      _isRefreshing = false;

      if (result.isRight()) {
        final res = result.getOrElse(() => throw Exception("Unexpected error"));
        if (res) {
          final newToken = DBService.ensure.getAccessToken();

          // Retry current request with new token
          final retryOptions = _cloneRequestWithNewToken(
            err.requestOptions,
            newToken,
          );

          try {
            final response = await dio.fetch(retryOptions);
            handler.resolve(response);
          } catch (e) {
            handler.reject(e as DioException);
          }

          // Process queued requests
          for (final item in _queue) {
            item.completion(newToken);
          }
          _queue.clear();
          return;
        }
      }

      // Refresh failed, reject all queued requests
      for (final item in _queue) {
        handler.reject(item.err);
      }
      _queue.clear();
    }

    return handler.next(err);
  }

  RequestOptions _cloneRequestWithNewToken(
    RequestOptions original,
    String newToken,
  ) {
    // IMPORTANT: Always include ALL required headers when retrying
    return original.copyWith(
      headers: {
        'Authorization': 'Bearer $newToken',
        'X-Request-UUID': Uuid().v4(),
        'X-Client-Lang': LangService.currentLocale,
        'X-Device-Type': 'Web', // This is CRITICAL for admin endpoints
      },
      extra: {...original.extra, 'retried': true},
    );
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
