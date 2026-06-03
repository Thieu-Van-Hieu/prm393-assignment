import 'package:dart_mappable/dart_mappable.dart';

part "login_request.mapper.dart";

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.encode,
)
class LoginRequest with LoginRequestMappable {
  String phoneNumber;
  String password;

  LoginRequest({required this.phoneNumber, required this.password});
}
