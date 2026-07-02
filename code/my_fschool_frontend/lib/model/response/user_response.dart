import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/model/response/user_workspace_response.dart';

part 'user_response.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class UserResponse with UserResponseMappable {
  String id;
  String fullName;
  String phoneNumber;
  String email;
  String? address;
  List<UserWorkspaceResponse> userWorkspaceResponses;

  UserResponse({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.address,
    required this.userWorkspaceResponses,
  });

  factory UserResponse.fromJson(String json) =>
      UserResponseMapper.fromJson(json);

  factory UserResponse.fromMap(Map<String, dynamic> map) =>
      UserResponseMapper.fromMap(map);
}
