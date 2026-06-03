// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'login_response.dart';

class LoginResponseMapper extends ClassMapperBase<LoginResponse> {
  LoginResponseMapper._();

  static LoginResponseMapper? _instance;
  static LoginResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginResponse';

  static String _$userid(LoginResponse v) => v.userid;
  static const Field<LoginResponse, String> _f$userid = Field(
    'userid',
    _$userid,
  );
  static String _$fullName(LoginResponse v) => v.fullName;
  static const Field<LoginResponse, String> _f$fullName = Field(
    'fullName',
    _$fullName,
  );
  static String _$role(LoginResponse v) => v.role;
  static const Field<LoginResponse, String> _f$role = Field('role', _$role);

  @override
  final MappableFields<LoginResponse> fields = const {
    #userid: _f$userid,
    #fullName: _f$fullName,
    #role: _f$role,
  };

  static LoginResponse _instantiate(DecodingData data) {
    return LoginResponse(
      userid: data.dec(_f$userid),
      fullName: data.dec(_f$fullName),
      role: data.dec(_f$role),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginResponse>(map);
  }

  static LoginResponse fromJson(String json) {
    return ensureInitialized().decodeJson<LoginResponse>(json);
  }
}

mixin LoginResponseMappable {}

