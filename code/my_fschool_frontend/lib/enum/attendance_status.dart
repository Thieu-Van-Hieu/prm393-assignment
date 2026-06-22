import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'attendance_status.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum AttendanceStatus {
  @MappableValue('ATTENDED')
  attended('Đã điểm danh', Colors.green, Colors.white),
  @MappableValue('ABSENT')
  absent('Vắng', Colors.red, Colors.white),
  @MappableValue('PENDING')
  notYet('Chưa điểm danh', Colors.orange, Colors.white);

  final String label;
  final Color bgColor;
  final Color textColor;

  const AttendanceStatus(this.label, this.bgColor, this.textColor);

  // Vẫn có thể giữ lại hàm từ String thủ công nếu phen thích gọi ở chỗ khác
  static AttendanceStatus fromString(String? status) {
    if (status == null) return AttendanceStatus.notYet;
    return AttendanceStatusMapper.fromValue(status.toUpperCase());
  }
}
