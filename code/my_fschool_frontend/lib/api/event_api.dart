import 'package:flutter/cupertino.dart';
import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/model/request/event_registration_request.dart';
import 'package:my_fschool_frontend/model/response/api_response.dart';
import 'package:my_fschool_frontend/model/response/event_response.dart';

class EventApi {
  final _dio = AppDio.client;
  final String requestPath = '/events';

  Future<ApiResponse<List<EventResponse>>> getEvents() async {
    try {
      final response = await _dio.get(requestPath);
      debugPrint('Events Response: ${response.data}');
      final events = (response.data as List)
          .map((event) => EventResponse.fromMap(event))
          .toList();
      return ApiResponse.success(events, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }

  Future<ApiResponse<bool>> register(EventRegistrationRequest request) async {
    try {
      final response = await _dio.post(
        "$requestPath/register",
        data: request.toJson(),
      );
      return ApiResponse.success(true, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(e);
    }
  }
}
