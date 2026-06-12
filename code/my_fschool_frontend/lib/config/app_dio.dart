import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_fschool_frontend/route/app_router.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';

class AppDio {
  static Dio? _dio;

  static const String ipv4Address = '192.168.1.8';
  static const String baseUrl = 'http://$ipv4Address:8080/api/v1';

  static Dio get client {
    if (_dio != null) return _dio!;

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      // Quá 10s không kết nối được -> sập
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);

    // Thêm Interceptor để log dữ liệu và bốc đầu Header
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Lấy JSESSIONID từ Secure Storage ra
          final jsessionId = await SessionManager.getSession();

          if (jsessionId != null) {
            // Ép cứng vào Header Cookie gửi lên cho Spring Boot nhận diện đúng chuẩn Session-based
            options.headers['Cookie'] = 'JSESSIONID=$jsessionId';
          }

          if (kDebugMode) {
            print('🚀 [API REQ] [${options.method}] -> ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '✅ [API RES] [${response.statusCode}] <- ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            print(
              '❌ [API ERR] [${e.response?.statusCode}] <- ${e.requestOptions.path}',
            );
          }

          if (e.response?.statusCode == 401) {
            await SessionManager.clear();
            AppRouter.router.go('/login');

            return handler.next(e);
          }

          String errorMessage = 'Kết nối đến server thất bại!';
          if (e.response?.data != null && e.response?.data is Map) {
            final data = e.response?.data as Map;
            errorMessage = data['message'] ?? data['error'] ?? errorMessage;
          }

          final customException = DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: e.type,
            error: errorMessage,
          );

          return handler.next(customException);
        },
      ),
    );

    return _dio!;
  }
}
