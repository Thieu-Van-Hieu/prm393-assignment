// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'student_profile_response.dart';

class StudentProfileResponseMapper
    extends ClassMapperBase<StudentProfileResponse> {
  StudentProfileResponseMapper._();

  static StudentProfileResponseMapper? _instance;
  static StudentProfileResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudentProfileResponseMapper._());
      ClassResponseMapper.ensureInitialized();
      AttendanceResponseMapper.ensureInitialized();
      ClubResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StudentProfileResponse';

  static String _$id(StudentProfileResponse v) => v.id;
  static const Field<StudentProfileResponse, String> _f$id = Field('id', _$id);
  static String _$studentCode(StudentProfileResponse v) => v.studentCode;
  static const Field<StudentProfileResponse, String> _f$studentCode = Field(
    'studentCode',
    _$studentCode,
  );
  static String _$fullName(StudentProfileResponse v) => v.fullName;
  static const Field<StudentProfileResponse, String> _f$fullName = Field(
    'fullName',
    _$fullName,
  );
  static DateTime _$dateOfBirth(StudentProfileResponse v) => v.dateOfBirth;
  static const Field<StudentProfileResponse, DateTime> _f$dateOfBirth = Field(
    'dateOfBirth',
    _$dateOfBirth,
  );
  static String _$gender(StudentProfileResponse v) => v.gender;
  static const Field<StudentProfileResponse, String> _f$gender = Field(
    'gender',
    _$gender,
  );
  static String? _$avatarUrl(StudentProfileResponse v) => v.avatarUrl;
  static const Field<StudentProfileResponse, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
    opt: true,
  );
  static ClassResponse? _$currentClass(StudentProfileResponse v) =>
      v.currentClass;
  static const Field<StudentProfileResponse, ClassResponse> _f$currentClass =
      Field('currentClass', _$currentClass, opt: true);
  static AttendanceResponse? _$todayAttendance(StudentProfileResponse v) =>
      v.todayAttendance;
  static const Field<StudentProfileResponse, AttendanceResponse>
  _f$todayAttendance = Field('todayAttendance', _$todayAttendance, opt: true);
  static ClubResponse? _$joinedClub(StudentProfileResponse v) => v.joinedClub;
  static const Field<StudentProfileResponse, ClubResponse> _f$joinedClub =
      Field('joinedClub', _$joinedClub, opt: true);

  @override
  final MappableFields<StudentProfileResponse> fields = const {
    #id: _f$id,
    #studentCode: _f$studentCode,
    #fullName: _f$fullName,
    #dateOfBirth: _f$dateOfBirth,
    #gender: _f$gender,
    #avatarUrl: _f$avatarUrl,
    #currentClass: _f$currentClass,
    #todayAttendance: _f$todayAttendance,
    #joinedClub: _f$joinedClub,
  };

  static StudentProfileResponse _instantiate(DecodingData data) {
    return StudentProfileResponse(
      id: data.dec(_f$id),
      studentCode: data.dec(_f$studentCode),
      fullName: data.dec(_f$fullName),
      dateOfBirth: data.dec(_f$dateOfBirth),
      gender: data.dec(_f$gender),
      avatarUrl: data.dec(_f$avatarUrl),
      currentClass: data.dec(_f$currentClass),
      todayAttendance: data.dec(_f$todayAttendance),
      joinedClub: data.dec(_f$joinedClub),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StudentProfileResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudentProfileResponse>(map);
  }

  static StudentProfileResponse fromJson(String json) {
    return ensureInitialized().decodeJson<StudentProfileResponse>(json);
  }
}

mixin StudentProfileResponseMappable {}

