import 'package:dart_mappable/dart_mappable.dart';

part 'change_password_request.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.encode)
class ChangePasswordRequest with ChangePasswordRequestMappable {
  String oldPassword;
  String newPassword;

  ChangePasswordRequest({required this.oldPassword, required this.newPassword});
}
