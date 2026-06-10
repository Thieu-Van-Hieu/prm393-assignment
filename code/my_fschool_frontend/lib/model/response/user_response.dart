import 'package:dart_mappable/dart_mappable.dart';

part 'user_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class UserResponse with UserResponseMappable {
  String fullName;
  String phoneNumber;
  String email;
  String roleName;

  UserResponse({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.roleName,
  });

  factory UserResponse.fromJson(String json) =>
      UserResponseMapper.fromJson(json);

  factory UserResponse.fromMap(Map<String, dynamic> map) =>
      UserResponseMapper.fromMap(map);
}
