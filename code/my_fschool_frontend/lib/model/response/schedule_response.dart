import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/enum/attendance_status.dart';

part 'schedule_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class ScheduleResponse with ScheduleResponseMappable {
  final String slotId;
  final String subjectName;
  final String teacherName;
  final String roomName;
  final int slotNumber;
  final String startTime;
  final String endTime;
  final AttendanceStatus attendanceStatus;

  ScheduleResponse({
    required this.slotId,
    required this.subjectName,
    required this.teacherName,
    required this.roomName,
    required this.slotNumber,
    required this.startTime,
    required this.endTime,
    required this.attendanceStatus,
  });

  static ScheduleResponse fromJson(String json) =>
      ScheduleResponseMapper.fromJson(json);

  static ScheduleResponse fromMap(Map<String, dynamic> map) =>
      ScheduleResponseMapper.fromMap(map);

  String get formattedTimeRange {
    final start = startTime.substring(0, 5);
    final end = endTime.substring(0, 5);
    return '$start - $end';
  }
}
