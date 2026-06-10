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

  // 3. API Lấy thông tin người dùng hiện tại
  Future<ApiResponse<UserResponse>> me() async {
    try {
      final response = await _dio.get('/auth/me');
      final userResponse = UserResponse.fromMap(response.data);
      return ApiResponse.success(userResponse, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  // 4. API đổi mật khẩu
  Future<ApiResponse<Response>> changePassword(
    ChangePasswordRequest changePasswordRequest,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/change-password',
        data: changePasswordRequest.toJson(),
      );
      return ApiResponse.success(response, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
