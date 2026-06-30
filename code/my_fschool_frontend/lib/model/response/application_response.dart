import 'package:dart_mappable/dart_mappable.dart';

part 'application_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods:
      GenerateMethods.decode, // Chỉ tạo hàm decode (fromJson/fromMap) giống mẫu
)
class ApplicationResponse with ApplicationResponseMappable {
  final String id;
  final String
  title; // Đã được BE dịch sang Tiếng Việt (e.g., 'Đơn xin nghỉ học')
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final String sentDate; // Định dạng chuỗi 'dd/MM/yyyy HH:mm'
  final String? processedDate; // Định dạng chuỗi 'dd/MM/yyyy HH:mm' (nullable)
  final String? handlerName; // Họ tên thầy cô duyệt đơn (nullable)
  final String? fromDate; // Ngày bắt đầu nghỉ 'dd/MM/yyyy' (nullable)
  final String? toDate; // Ngày kết thúc nghỉ 'dd/MM/yyyy' (nullable)
  final String requestContent; // Lý do phụ huynh viết đơn
  final String? responseContent; // Phản hồi từ nhà trường (nullable)

  const ApplicationResponse({
    required this.id,
    required this.title,
    required this.status,
    required this.sentDate,
    this.processedDate,
    this.handlerName,
    this.fromDate,
    this.toDate,
    required this.requestContent,
    this.responseContent,
  });

  static ApplicationResponse fromJson(String json) =>
      ApplicationResponseMapper.fromJson(json);

  static ApplicationResponse fromMap(Map<String, dynamic> map) =>
      ApplicationResponseMapper.fromMap(map);
}
