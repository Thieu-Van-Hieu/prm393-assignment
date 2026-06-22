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
      UserWorkspaceResponseMapper.ensureInitialized();
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
  static List<UserWorkspaceResponse> _$userWorkspaceResponses(UserResponse v) =>
      v.userWorkspaceResponses;
  static const Field<UserResponse, List<UserWorkspaceResponse>>
  _f$userWorkspaceResponses = Field(
    'userWorkspaceResponses',
    _$userWorkspaceResponses,
  );

  @override
  final MappableFields<UserResponse> fields = const {
    #id: _f$id,
    #fullName: _f$fullName,
    #phoneNumber: _f$phoneNumber,
    #email: _f$email,
    #address: _f$address,
    #userWorkspaceResponses: _f$userWorkspaceResponses,
  };

  static UserResponse _instantiate(DecodingData data) {
    return UserResponse(
      id: data.dec(_f$id),
      fullName: data.dec(_f$fullName),
      phoneNumber: data.dec(_f$phoneNumber),
      email: data.dec(_f$email),
      address: data.dec(_f$address),
      userWorkspaceResponses: data.dec(_f$userWorkspaceResponses),
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

