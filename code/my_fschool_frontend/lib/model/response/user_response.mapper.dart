// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_response.dart';

class UserResponseMapper extends ClassMapperBase<UserResponse> {
  UserResponseMapper._();

  static UserResponseMapper? _instance;
  static UserResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserResponseMapper._());
      StudentProfileResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserResponse';

  static String _$id(UserResponse v) => v.id;
  static const Field<UserResponse, String> _f$id = Field('id', _$id);
  static String _$fullName(UserResponse v) => v.fullName;
  static const Field<UserResponse, String> _f$fullName = Field(
    'fullName',
    _$fullName,
  );
  static String _$phoneNumber(UserResponse v) => v.phoneNumber;
  static const Field<UserResponse, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
  );
  static String _$email(UserResponse v) => v.email;
  static const Field<UserResponse, String> _f$email = Field('email', _$email);
  static String? _$address(UserResponse v) => v.address;
  static const Field<UserResponse, String> _f$address = Field(
    'address',
    _$address,
    opt: true,
  );
  static String _$roleName(UserResponse v) => v.roleName;
  static const Field<UserResponse, String> _f$roleName = Field(
    'roleName',
    _$roleName,
  );
  static StudentProfileResponse? _$studentProfile(UserResponse v) =>
      v.studentProfile;
  static const Field<UserResponse, StudentProfileResponse> _f$studentProfile =
      Field('studentProfile', _$studentProfile, opt: true);
  static List<StudentProfileResponse>? _$parentStudents(UserResponse v) =>
      v.parentStudents;
  static const Field<UserResponse, List<StudentProfileResponse>>
  _f$parentStudents = Field('parentStudents', _$parentStudents, opt: true);

  @override
  final MappableFields<UserResponse> fields = const {
    #id: _f$id,
    #fullName: _f$fullName,
    #phoneNumber: _f$phoneNumber,
    #email: _f$email,
    #address: _f$address,
    #roleName: _f$roleName,
    #studentProfile: _f$studentProfile,
    #parentStudents: _f$parentStudents,
  };

  static UserResponse _instantiate(DecodingData data) {
    return UserResponse(
      id: data.dec(_f$id),
      fullName: data.dec(_f$fullName),
      phoneNumber: data.dec(_f$phoneNumber),
      email: data.dec(_f$email),
      address: data.dec(_f$address),
      roleName: data.dec(_f$roleName),
      studentProfile: data.dec(_f$studentProfile),
      parentStudents: data.dec(_f$parentStudents),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserResponse>(map);
  }

  static UserResponse fromJson(String json) {
    return ensureInitialized().decodeJson<UserResponse>(json);
  }
}

mixin UserResponseMappable {}

