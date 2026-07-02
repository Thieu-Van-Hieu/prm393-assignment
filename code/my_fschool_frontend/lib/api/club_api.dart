import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/response/api_response.dart';
import 'package:my_fschool_frontend/model/response/student_clubs_response.dart';

class ClubApi {
  final _dio = AppDio.client;
  final String baseUrl = '/clubs';

  Future<ApiResponse<StudentClubsResponse>> getStudentClubs(
    String studentId,
  ) async {
    try {
      final response = await _dio.get(
        '$baseUrl/student',
        queryParameters: {'studentId': studentId.toString()},
      );
      return ApiResponse.success(
        StudentClubsResponse.fromMap(response.data as Map<String, dynamic>),
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
