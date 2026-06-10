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
    }
    return _instance!;
  }

  @override
  final String id = 'UserResponse';

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
  static String _$roleName(UserResponse v) => v.roleName;
  static const Field<UserResponse, String> _f$roleName = Field(
    'roleName',
    _$roleName,
  );

  @override
  final MappableFields<UserResponse> fields = const {
    #fullName: _f$fullName,
    #phoneNumber: _f$phoneNumber,
    #email: _f$email,
    #roleName: _f$roleName,
  };

  static UserResponse _instantiate(DecodingData data) {
    return UserResponse(
      fullName: data.dec(_f$fullName),
      phoneNumber: data.dec(_f$phoneNumber),
      email: data.dec(_f$email),
      roleName: data.dec(_f$roleName),
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

