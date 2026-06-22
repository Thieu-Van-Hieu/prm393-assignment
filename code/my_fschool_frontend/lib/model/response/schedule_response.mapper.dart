// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'schedule_response.dart';

class ScheduleResponseMapper extends ClassMapperBase<ScheduleResponse> {
  ScheduleResponseMapper._();

  static ScheduleResponseMapper? _instance;
  static ScheduleResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduleResponseMapper._());
      AttendanceStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScheduleResponse';

  static String _$slotId(ScheduleResponse v) => v.slotId;
  static const Field<ScheduleResponse, String> _f$slotId = Field(
    'slotId',
    _$slotId,
  );
  static String _$subjectName(ScheduleResponse v) => v.subjectName;
  static const Field<ScheduleResponse, String> _f$subjectName = Field(
    'subjectName',
    _$subjectName,
  );
  static String _$teacherName(ScheduleResponse v) => v.teacherName;
  static const Field<ScheduleResponse, String> _f$teacherName = Field(
    'teacherName',
    _$teacherName,
  );
  static String _$roomName(ScheduleResponse v) => v.roomName;
  static const Field<ScheduleResponse, String> _f$roomName = Field(
    'roomName',
    _$roomName,
  );
  static int _$slotNumber(ScheduleResponse v) => v.slotNumber;
  static const Field<ScheduleResponse, int> _f$slotNumber = Field(
    'slotNumber',
    _$slotNumber,
  );
  static String _$startTime(ScheduleResponse v) => v.startTime;
  static const Field<ScheduleResponse, String> _f$startTime = Field(
    'startTime',
    _$startTime,
  );
  static String _$endTime(ScheduleResponse v) => v.endTime;
  static const Field<ScheduleResponse, String> _f$endTime = Field(
    'endTime',
    _$endTime,
  );
  static AttendanceStatus _$attendanceStatus(ScheduleResponse v) =>
      v.attendanceStatus;
  static const Field<ScheduleResponse, AttendanceStatus> _f$attendanceStatus =
      Field('attendanceStatus', _$attendanceStatus);

  @override
  final MappableFields<ScheduleResponse> fields = const {
    #slotId: _f$slotId,
    #subjectName: _f$subjectName,
    #teacherName: _f$teacherName,
    #roomName: _f$roomName,
    #slotNumber: _f$slotNumber,
    #startTime: _f$startTime,
    #endTime: _f$endTime,
    #attendanceStatus: _f$attendanceStatus,
  };

  static ScheduleResponse _instantiate(DecodingData data) {
    return ScheduleResponse(
      slotId: data.dec(_f$slotId),
      subjectName: data.dec(_f$subjectName),
      teacherName: data.dec(_f$teacherName),
      roomName: data.dec(_f$roomName),
      slotNumber: data.dec(_f$slotNumber),
      startTime: data.dec(_f$startTime),
      endTime: data.dec(_f$endTime),
      attendanceStatus: data.dec(_f$attendanceStatus),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScheduleResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScheduleResponse>(map);
  }

  static ScheduleResponse fromJson(String json) {
    return ensureInitialized().decodeJson<ScheduleResponse>(json);
  }
}

mixin ScheduleResponseMappable {}

