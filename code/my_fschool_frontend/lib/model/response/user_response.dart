import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/model/response/student_profile_response.dart';

part 'user_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class UserResponse with UserResponseMappable {
  String id;
  String fullName;
  String phoneNumber;
  String email;
  String? address;
  String roleName; // 'PARENT' hoặc 'STUDENT'
  StudentProfileResponse? studentProfile; // Trả về nếu roleName là STUDENT
  List<StudentProfileResponse>?
  parentStudents; // Danh sách các con nếu là PARENT

  UserResponse({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.address,
    required this.roleName,
    this.studentProfile,
    this.parentStudents,
  });

  factory UserResponse.fromJson(String json) =>
      UserResponseMapper.fromJson(json);

  factory UserResponse.fromMap(Map<String, dynamic> map) =>
      UserResponseMapper.fromMap(map);
}
