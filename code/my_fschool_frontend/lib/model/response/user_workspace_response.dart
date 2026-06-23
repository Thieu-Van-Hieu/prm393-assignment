import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/model/response/student_profile_response.dart';

part 'user_workspace_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class UserWorkspaceResponse with UserWorkspaceResponseMappable {
  String classId;
  String className;
  String schoolYear;
  String roleName;
  StudentProfileResponse profile;

  UserWorkspaceResponse({
    required this.classId,
    required this.className,
    required this.schoolYear,
    required this.roleName,
    required this.profile,
  });

  factory UserWorkspaceResponse.fromJson(String json) =>
      UserWorkspaceResponseMapper.fromJson(json);

  factory UserWorkspaceResponse.fromMap(Map<String, dynamic> map) =>
      UserWorkspaceResponseMapper.fromMap(map);
}
