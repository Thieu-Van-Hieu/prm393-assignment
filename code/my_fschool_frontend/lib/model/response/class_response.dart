import 'package:dart_mappable/dart_mappable.dart';

part 'class_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class ClassResponse with ClassResponseMappable {
  String id;
  String className;
  String schoolYear;

  ClassResponse({
    required this.id,
    required this.className,
    required this.schoolYear,
  });

  factory ClassResponse.fromJson(String json) =>
      ClassResponseMapper.fromJson(json);

  factory ClassResponse.fromMap(Map<String, dynamic> map) =>
      ClassResponseMapper.fromMap(map);
}
