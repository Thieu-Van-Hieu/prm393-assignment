// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'login_request.dart';

class LoginRequestMapper extends ClassMapperBase<LoginRequest> {
  LoginRequestMapper._();

  static LoginRequestMapper? _instance;
  static LoginRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginRequest';

  static String _$phoneNumber(LoginRequest v) => v.phoneNumber;
  static const Field<LoginRequest, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
  );
  static String _$password(LoginRequest v) => v.password;
  static const Field<LoginRequest, String> _f$password = Field(
    'password',
    _$password,
  );

  @override
  final MappableFields<LoginRequest> fields = const {
    #phoneNumber: _f$phoneNumber,
    #password: _f$password,
  };

  static LoginRequest _instantiate(DecodingData data) {
    return LoginRequest(
      phoneNumber: data.dec(_f$phoneNumber),
      password: data.dec(_f$password),
    );
  }

  @override
  final Function instantiate = _instantiate;
}

mixin LoginRequestMappable {
  String toJson() {
    return LoginRequestMapper.ensureInitialized().encodeJson<LoginRequest>(
      this as LoginRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return LoginRequestMapper.ensureInitialized().encodeMap<LoginRequest>(
      this as LoginRequest,
    );
  }
}

