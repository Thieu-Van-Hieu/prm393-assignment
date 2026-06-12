// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'attendance_response.dart';

class AttendanceResponseMapper extends ClassMapperBase<AttendanceResponse> {
  AttendanceResponseMapper._();

  static AttendanceResponseMapper? _instance;
  static AttendanceResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AttendanceResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AttendanceResponse';

  static String _$id(AttendanceResponse v) => v.id;
  static const Field<AttendanceResponse, String> _f$id = Field('id', _$id);
  static DateTime _$attendanceDate(AttendanceResponse v) => v.attendanceDate;
  static const Field<AttendanceResponse, DateTime> _f$attendanceDate = Field(
    'attendanceDate',
    _$attendanceDate,
  );
  static DateTime _$recordedAt(AttendanceResponse v) => v.recordedAt;
  static const Field<AttendanceResponse, DateTime> _f$recordedAt = Field(
    'recordedAt',
    _$recordedAt,
  );
  static String _$status(AttendanceResponse v) => v.status;
  static const Field<AttendanceResponse, String> _f$status = Field(
    'status',
    _$status,
  );

  @override
  final MappableFields<AttendanceResponse> fields = const {
    #id: _f$id,
    #attendanceDate: _f$attendanceDate,
    #recordedAt: _f$recordedAt,
    #status: _f$status,
  };

  static AttendanceResponse _instantiate(DecodingData data) {
    return AttendanceResponse(
      id: data.dec(_f$id),
      attendanceDate: data.dec(_f$attendanceDate),
      recordedAt: data.dec(_f$recordedAt),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AttendanceResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AttendanceResponse>(map);
  }

  static AttendanceResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AttendanceResponse>(json);
  }
}

mixin AttendanceResponseMappable {}

