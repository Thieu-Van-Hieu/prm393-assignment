import 'package:dio/dio.dart';
import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/request/change_password_request.dart';
import 'package:my_fschool_frontend/model/request/forgot_password_request.dart';
import 'package:my_fschool_frontend/model/request/login_request.dart';
import 'package:my_fschool_frontend/model/response/api_response.dart';
import 'package:my_fschool_frontend/model/response/user_response.dart';

class AuthApi {
  final _dio = AppDio.client;

  // 1. API Đăng nhập
  Future<ApiResponse<Response>> login({
    required LoginRequest loginRequest,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: loginRequest.toJson(),
      );
      return ApiResponse.success(response, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e); // Tự bóc tách lỗi trong 1 nốt nhạc
    }
  }

  // 2. API Quên mật khẩu
  Future<ApiResponse<Response>> forgotPassword({
    required ForgotPasswordRequest forgotPasswordRequest,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: forgotPasswordRequest.toJson(),
      );
      return ApiResponse.success(response, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  // Hàm helper bóc tách thông điệp lỗi trả về từ Spring Boot (thường nằm trong map 'message')
  String _getErrorMessage(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
    }
  }
}
