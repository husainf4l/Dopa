import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage_service.dart';

class ApiClient {
  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5081/api'),
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    final storage = SecureStorageService(const FlutterSecureStorage());
    _dio.interceptors.add(_AuthInterceptor(storage));
  }

  final Dio _dio;

  Dio get client => _dio;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this.storage);

  final SecureStorageService storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await storage.clearToken();
    }
    handler.next(err);
  }
}
