import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/model/request/login_request.dart';

part 'login_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class LoginResponse with LoginRequestMappable {
  final String userid;
  final String fullName;
  final String role;

  LoginResponse({
    required this.userid,
    required this.fullName,
    required this.role,
  });

  static LoginResponse fromJson(String json) {
    return LoginResponseMapper.fromJson(json);
  }

  static LoginResponse fromMap(Map<String, dynamic> map) {
    return LoginResponseMapper.fromMap(map);
  }
}
