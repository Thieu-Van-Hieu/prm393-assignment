import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/response/api_response.dart';
import 'package:my_fschool_frontend/model/response/schedule_response.dart';

class ScheduleApi {
  final _dio = AppDio.client;

  Future<ApiResponse<List<ScheduleResponse>>> getStudentSchedule({
    required String studentId,
    DateTime? date,
  }) async {
    try {
      // 1. Khởi tạo Query Parameters bám sát cấu trúc @RequestParam ở Backend
      final Map<String, dynamic> queryParameters = {'studentId': studentId};

      // 2. Nếu có truyền ngày, convert định dạng DateTime sang chuỗi 'YYYY-MM-DD' chuẩn ISO
      if (date != null) {
        queryParameters['date'] = date.toIso8601String().split('T')[0];
      }

      // 3. Thực hiện gọi HTTP GET API sang Route `/api/v1/schedules`
      final response = await _dio.get(
        '/schedules',
        queryParameters: queryParameters,
      );

      // 4. Map danh sách JSON nhận được sang List<ScheduleResponse>
      final List<dynamic> rawList = response.data;
      final scheduleList = rawList
          .map((jsonItem) => ScheduleResponse.fromMap(jsonItem))
          .toList();

      return ApiResponse.success(scheduleList, statusCode: response.statusCode);
    } catch (e) {
      // Tự bóc tách lỗi và đóng gói vào ApiResponse.error cực kỳ đồng bộ
      return ApiResponse.error(e);
    }
  }
}
