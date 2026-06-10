// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'change_password_request.dart';

class ChangePasswordRequestMapper
    extends ClassMapperBase<ChangePasswordRequest> {
  ChangePasswordRequestMapper._();

  static ChangePasswordRequestMapper? _instance;
  static ChangePasswordRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChangePasswordRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChangePasswordRequest';

  static String _$oldPassword(ChangePasswordRequest v) => v.oldPassword;
  static const Field<ChangePasswordRequest, String> _f$oldPassword = Field(
    'oldPassword',
    _$oldPassword,
  );
  static String _$newPassword(ChangePasswordRequest v) => v.newPassword;
  static const Field<ChangePasswordRequest, String> _f$newPassword = Field(
    'newPassword',
    _$newPassword,
  );

  @override
  final MappableFields<ChangePasswordRequest> fields = const {
    #oldPassword: _f$oldPassword,
    #newPassword: _f$newPassword,
  };

  static ChangePasswordRequest _instantiate(DecodingData data) {
    return ChangePasswordRequest(
      oldPassword: data.dec(_f$oldPassword),
      newPassword: data.dec(_f$newPassword),
    );
  }

  @override
  final Function instantiate = _instantiate;
}

mixin ChangePasswordRequestMappable {
  String toJson() {
    return ChangePasswordRequestMapper.ensureInitialized()
        .encodeJson<ChangePasswordRequest>(this as ChangePasswordRequest);
  }

  Map<String, dynamic> toMap() {
    return ChangePasswordRequestMapper.ensureInitialized()
        .encodeMap<ChangePasswordRequest>(this as ChangePasswordRequest);
  }
}

