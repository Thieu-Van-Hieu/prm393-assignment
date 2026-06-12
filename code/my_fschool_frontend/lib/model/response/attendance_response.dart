import 'package:dart_mappable/dart_mappable.dart';

part 'attendance_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class AttendanceResponse with AttendanceResponseMappable {
  String id;
  DateTime attendanceDate;
  DateTime recordedAt;
  String status; // 'ATTENDED', 'ABSENT', 'PENDING'

  AttendanceResponse({
    required this.id,
    required this.attendanceDate,
    required this.recordedAt,
    required this.status,
  });

  factory AttendanceResponse.fromJson(String json) =>
      AttendanceResponseMapper.fromJson(json);

  factory AttendanceResponse.fromMap(Map<String, dynamic> map) =>
      AttendanceResponseMapper.fromMap(map);
}
