import 'package:dart_mappable/dart_mappable.dart';

part 'forgot_password_request.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.encode)
class ForgotPasswordRequest with ForgotPasswordRequestMappable {
  final String phoneNumber;

  ForgotPasswordRequest({required this.phoneNumber});
}
