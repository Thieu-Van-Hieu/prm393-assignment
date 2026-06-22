// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_workspace_response.dart';

class UserWorkspaceResponseMapper
    extends ClassMapperBase<UserWorkspaceResponse> {
  UserWorkspaceResponseMapper._();

  static UserWorkspaceResponseMapper? _instance;
  static UserWorkspaceResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserWorkspaceResponseMapper._());
      StudentProfileResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserWorkspaceResponse';

  static String _$classId(UserWorkspaceResponse v) => v.classId;
  static const Field<UserWorkspaceResponse, String> _f$classId = Field(
    'classId',
    _$classId,
  );
  static String _$className(UserWorkspaceResponse v) => v.className;
  static const Field<UserWorkspaceResponse, String> _f$className = Field(
    'className',
    _$className,
  );
  static String _$schoolYear(UserWorkspaceResponse v) => v.schoolYear;
  static const Field<UserWorkspaceResponse, String> _f$schoolYear = Field(
    'schoolYear',
    _$schoolYear,
  );
  static String _$roleName(UserWorkspaceResponse v) => v.roleName;
  static const Field<UserWorkspaceResponse, String> _f$roleName = Field(
    'roleName',
    _$roleName,
  );
  static StudentProfileResponse _$profile(UserWorkspaceResponse v) => v.profile;
  static const Field<UserWorkspaceResponse, StudentProfileResponse> _f$profile =
      Field('profile', _$profile);

  @override
  final MappableFields<UserWorkspaceResponse> fields = const {
    #classId: _f$classId,
    #className: _f$className,
    #schoolYear: _f$schoolYear,
    #roleName: _f$roleName,
    #profile: _f$profile,
  };

  static UserWorkspaceResponse _instantiate(DecodingData data) {
    return UserWorkspaceResponse(
      classId: data.dec(_f$classId),
      className: data.dec(_f$className),
      schoolYear: data.dec(_f$schoolYear),
      roleName: data.dec(_f$roleName),
      profile: data.dec(_f$profile),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserWorkspaceResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserWorkspaceResponse>(map);
  }

  static UserWorkspaceResponse fromJson(String json) {
    return ensureInitialized().decodeJson<UserWorkspaceResponse>(json);
  }
}

mixin UserWorkspaceResponseMappable {}

