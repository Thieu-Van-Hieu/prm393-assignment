import 'package:dio/dio.dart';
import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/request/forgot_password_request.dart';
import 'package:my_fschool_frontend/model/request/login_request.dart';

class AuthApi {
  final _dio = AppDio.client;

  // 1. API Đăng nhập
  Future<Response?> login({required LoginRequest loginRequest}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: loginRequest.toJson(),
      );
      return response;
    } on DioException catch (e) {
      // Bắn lỗi ra ngoài cho UI hứng
      throw _getErrorMessage(e);
    }
  }

  // 2. API Quên mật khẩu (Gửi lệnh kích hoạt SMS Gateway / OTP)
  Future<Response?> forgotPassword({
    required ForgotPasswordRequest forgotPasswordRequest,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: forgotPasswordRequest.toJson(),
      );
      return response;
    } on DioException catch (e) {
      throw _getErrorMessage(e);
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
    return 'Kết nối đến server thất bại. Vui lòng thử lại sau!';
  }
}
