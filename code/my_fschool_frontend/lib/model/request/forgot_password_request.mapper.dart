// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'forgot_password_request.dart';

class ForgotPasswordRequestMapper
    extends ClassMapperBase<ForgotPasswordRequest> {
  ForgotPasswordRequestMapper._();

  static ForgotPasswordRequestMapper? _instance;
  static ForgotPasswordRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ForgotPasswordRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ForgotPasswordRequest';

  static String _$phoneNumber(ForgotPasswordRequest v) => v.phoneNumber;
  static const Field<ForgotPasswordRequest, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
  );

  @override
  final MappableFields<ForgotPasswordRequest> fields = const {
    #phoneNumber: _f$phoneNumber,
  };

  static ForgotPasswordRequest _instantiate(DecodingData data) {
    return ForgotPasswordRequest(phoneNumber: data.dec(_f$phoneNumber));
  }

  @override
  final Function instantiate = _instantiate;
}

mixin ForgotPasswordRequestMappable {
  String toJson() {
    return ForgotPasswordRequestMapper.ensureInitialized()
        .encodeJson<ForgotPasswordRequest>(this as ForgotPasswordRequest);
  }

  Map<String, dynamic> toMap() {
    return ForgotPasswordRequestMapper.ensureInitialized()
        .encodeMap<ForgotPasswordRequest>(this as ForgotPasswordRequest);
  }
}

