import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/response/api_response.dart';
import 'package:my_fschool_frontend/model/response/application_response.dart';

class ApplicationApi {
  // Khởi tạo client global từ cấu hình hệ thống xử lý Session ngầm định
  final _dio = AppDio.client;

  /// 🎯 1. Phụ huynh lấy danh sách đơn từ của con mình đã nộp
  Future<ApiResponse<List<ApplicationResponse>>>
  getApplicationsByParent() async {
    try {
      final response = await _dio.get('/applications/parent');

      final List<dynamic> rawList = response.data;
      final applicationList = rawList.map((jsonItem) {
        return ApplicationResponse.fromMap(jsonItem as Map<String, dynamic>);
      }).toList();

      return ApiResponse.success(
        applicationList,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// 🎯 2. Phụ huynh nộp một đơn từ mới lên hệ thống
  Future<ApiResponse<ApplicationResponse>> createApplication({
    required String studentId,
    required String applicationType, // 'SICK_LEAVE' hoặc 'ACTIVITY_EXEMPTION'
    required String reason,
    String?
    fromDate, // Định dạng 'yyyy-MM-dd' hoặc gửi Object DateTime tùy cấu hình Jackson BE
    String? toDate,
  }) async {
    try {
      final response = await _dio.post(
        '/applications',
        data: {
          'studentId': studentId,
          'applicationType': applicationType,
          'reason': reason,
          'fromDate': ?fromDate,
          'toDate': ?toDate,
        },
      );

      final result = ApplicationResponse.fromMap(
        response.data as Map<String, dynamic>,
      );
      return ApiResponse.success(result, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
