import 'package:dio/dio.dart';

class ApiResponse<T> {
  final T? data; // Dữ liệu thành công trả về (Ví dụ: Response, Map, hoặc Model)
  final String? errorMessage; // Chuỗi lỗi sạch đẹp bằng tiếng Việt
  final int? statusCode; // Mã HTTP Status (200, 400, 401, 500...)

  const ApiResponse._({this.data, this.errorMessage, this.statusCode});

  // Gợi ý cho UI: Kiểm tra xem API chạy mượt hay tạch
  bool get isSuccess => errorMessage == null;

  bool get hasError => errorMessage != null;

  // Factory tạo instance khi API Thành công
  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse._(data: data, statusCode: statusCode);
  }

  // Factory tạo instance tự động bóc tách khi API Thất bại
  factory ApiResponse.error(Object error) {
    int? statusCode;
    String message = 'Kết nối đến server thất bại. Vui lòng thử lại sau!';

    if (error is DioException) {
      statusCode = error.response?.statusCode;
      final responseData = error.response?.data;

      if (responseData != null && responseData is Map) {
        // Tự động quét tất cả các loại key lỗi mà Spring Boot hay nhả về
        message =
            responseData['message'] ??
            responseData['error'] ??
            responseData['details'] ??
            message;
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        message = 'Quá thời gian kết nối đến máy chủ!';
      }
    } else {
      message = error.toString();
    }

    return ApiResponse._(errorMessage: message, statusCode: statusCode);
  }
}
