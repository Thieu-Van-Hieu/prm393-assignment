import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_fschool_frontend/route/app_router.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';

class AppDio {
  static Dio? _dio;

  static const String backendService = 'fschool-backend';
  static String backendAddress = '192.168.1.1';
  static String baseUrl = 'http://$backendAddress:8080/api/v1';

  // --- THÊM HÀM NÀY VÀO CLASS CỦA BẠN ---
  static void updateBaseUrl(String host, int port) {
    // Cập nhật lại chuỗi baseUrl của class theo IP/Port tìm được từ mDNS
    baseUrl = 'http://$host:$port/api/v1';

    if (_dio != null) {
      // Nếu client đã được khởi tạo trước đó, cập nhật trực tiếp options của nó
      _dio!.options.baseUrl = baseUrl;
    } else {
      // Nếu client chưa khởi tạo, lần đầu gọi AppDio.client nó sẽ tự lấy baseUrl mới ở trên
      client;
    }

    if (kDebugMode) {
      print('🔄 [AppDio] Đã cập nhật Backend URL mới: $baseUrl');
    }
  }

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
