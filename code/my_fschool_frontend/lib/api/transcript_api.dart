import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/response/api_response.dart';
import 'package:my_fschool_frontend/model/response/semester_transcript_response.dart'; // 🎯 Import model mới tạo

class TranscriptApi {
  // Khởi tạo client global từ cấu hình hệ thống giống ScheduleApi
  final _dio = AppDio.client;

  /// Lấy toàn bộ danh sách bảng điểm gom theo học kỳ của học sinh
  Future<ApiResponse<List<SemesterTranscriptResponse>>> getTranscript({
    required String studentId,
  }) async {
    try {
      // 1. Gọi API với endpoint và query parameters
      final response = await _dio.get(
        '/transcripts',
        queryParameters: {'studentId': studentId},
      );

      // 2. Ép kiểu dữ liệu sang List của SemesterTranscriptResponse bằng dart_mappable
      final List<dynamic> rawList = response.data;
      final transcriptList = rawList.map((jsonItem) {
        return SemesterTranscriptResponse.fromMap(
          jsonItem as Map<String, dynamic>,
        );
      }).toList();

      // 3. Đóng gói thành công trả về cho Notifier xử lý tiếp
      return ApiResponse.success(
        transcriptList,
        statusCode: response.statusCode,
      );
    } catch (e) {
      // 4. Tự bóc tách lỗi dập khuôn hệ thống
      return ApiResponse.error(e);
    }
  }
}
