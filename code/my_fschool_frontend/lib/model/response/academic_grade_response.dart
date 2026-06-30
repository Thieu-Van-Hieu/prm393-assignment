import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/enum/subject_type.dart';

part 'academic_grade_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class AcademicGradeResponse with AcademicGradeResponseMappable {
  final String subjectName;
  final SubjectType type;
  final List<int>? regularScores;
  final double? midTermScore;
  final double? finalTermScore;
  final double? summaryScore;
  final String? qualitativeResult;
  final String teacherComment;

  const AcademicGradeResponse({
    required this.subjectName,
    required this.type,
    this.regularScores,
    this.midTermScore,
    this.finalTermScore,
    this.summaryScore,
    this.qualitativeResult,
    required this.teacherComment,
  });

  static const fromMap = AcademicGradeResponseMapper.fromMap;
  static const fromJson = AcademicGradeResponseMapper.fromJson;
}
