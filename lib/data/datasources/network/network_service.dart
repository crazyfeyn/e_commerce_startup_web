import 'dart:io';

import 'package:e_commerce_startup_web/core/services/lang_service.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class NetworkService {
  static bool _isTester = true;
  static final _serverDev = "http://131.153.18.44:8080";
  static final _serverProd = "http://131.153.18.44:8080";

  static String get getService {
    if (_isTester) return _serverDev;
    return _serverProd;
  }

  static Map<String, String?> get getHeaders {
    final langCode = LangService.currentLocale;
    final accessToken = DBService.ensure.getAccessToken();
    return {
      "Authorization": "Bearer $accessToken",
      "X-Request-UUID": Uuid().v4(),
      "X-Client-Lang": langCode,
      "X-Device-Type": "Web",
    };
  }

  static Dio get _dio {
    final dio = Dio(BaseOptions(baseUrl: getService, headers: getHeaders))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio..interceptors.add(NetworkInterceptor(dio));
  }

  /* Http Requests */
  static Future<T?> get<T>(
    String api,
    CancelToken cancelToken, [
    Map<String, dynamic>? params,
  ]) async {
    try {
      var response = await _dio.get(
        api,
        queryParameters: params,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } on SocketException catch (_) {
      throw NetworkException(
        LocaleKeys.check_internet_connection.tr(),
        NetworkExceptionType.noInternet,
      );
    } catch (e) {
      throw NetworkException(
        LocaleKeys.dio_unknown_message.tr(args: [e.toString()]),
        NetworkExceptionType.unknown,
      );
    }
  }

  static Future<T?> post<T>(
    String api,
    CancelToken cancelToken, [
    Object? data,
    Map<String, dynamic>? params,
  ]) async {
    try {
      var response = await _dio.post(
        api,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } on SocketException catch (_) {
      throw NetworkException(
        LocaleKeys.check_internet_connection.tr(),
        NetworkExceptionType.noInternet,
      );
    } catch (e) {
      throw NetworkException(
        LocaleKeys.dio_unknown_message.tr(args: [e.toString()]),
        NetworkExceptionType.unknown,
      );
    }
  }

  static Future<T?> put<T>(
    String api,
    CancelToken cancelToken, [
    Object? data,
    Map<String, dynamic>? queryParameters,
  ]) async {
    try {
      var response = await _dio.put(api, data: data, queryParameters: queryParameters, cancelToken: cancelToken);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } on SocketException catch (_) {
      throw NetworkException(
        LocaleKeys.check_internet_connection.tr(),
        NetworkExceptionType.noInternet,
      );
    } catch (e) {
      throw NetworkException(
        LocaleKeys.dio_unknown_message.tr(args: [e.toString()]),
        NetworkExceptionType.unknown,
      );
    }
  }

  static Future<T?> delete<T>(
    String api,
    CancelToken cancelToken, [
    Map<String, dynamic>? params,
  ]) async {
    try {
      var response = await _dio.delete(
        api,
        queryParameters: params,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } on SocketException catch (_) {
      throw NetworkException(
        LocaleKeys.check_internet_connection.tr(),
        NetworkExceptionType.noInternet,
      );
    } catch (e) {
      throw NetworkException(
        LocaleKeys.dio_unknown_message.tr(args: [e.toString()]),
        NetworkExceptionType.unknown,
      );
    }
  }

  /* Http Apis */
  static final String apiLogin = "/api/v1/auth/login";
  static final String apiRefreshToken = "/api/v1/auth/refresh-token";

  static final String apiFetchCategories = "/api/v1/admin/product-category/get-all";
  static final String apiCreateCategory = "/api/v1/admin/product-category/create";
  static final String apiEditCategory = "/api/v1/admin/product-category/edit";
  static final String apiDeleteCategory = "/api/v1/admin/product-category/delete";

  static final String apiFetchProducts = "/api/v1/admin/product/get-all";
  static final String apiCreateProduct = "/api/v1/admin/product/create";
  static final String apiEditProduct = "/api/v1/admin/product/edit";
  static final String apiDeleteProduct = "/api/v1/admin/product/delete";
  static final String apiUploadImageProduct = "/api/v1/admin/product/upload-images";

  static final String apiFetchMeasurement = "/api/v1/measurement/all";
  static String apiFileDownload(String identity) => "/api/v1/file/download?identity=$identity";

  /* Http Params */
  static Map<String, dynamic> paramsLogin(String phone, String password) {
    return {"phoneNumber": phone, "password": password};
  }

  static Map<String, dynamic> paramsRefreshToken(
    String clientId,
    String refreshToken,
  ) {
    return {"clientId": clientId, "refreshToken": refreshToken};
  }

  static Map<String, dynamic> paramsCategory(
    Map<String, dynamic> title,
    String prompt,
  ) {
    return {"description": prompt, "titleData": title};
  }

  static Map<String, dynamic> paramsEditCategory(int categoryId) {
    return { "categoryId": categoryId };
  }

  static Map<String, dynamic> paramsEditProduct(int productId) {
    return { "productId": productId };
  }
}
