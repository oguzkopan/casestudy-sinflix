import 'package:dio/dio.dart';
import 'package:sin_flix/core/services/storage_service.dart';
import 'package:sin_flix/core/di/injector.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService = getIt<StorageService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path != '/user/login' && options.path != '/user/register') {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      getIt<StorageService>().deleteToken();
      getIt<StorageService>().deleteUser();
    }
    super.onError(err, handler);
  }
}