import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/model/response/academic_grade_response.dart';

part 'semester_transcript_response.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class SemesterTranscriptResponse with SemesterTranscriptResponseMappable {
  final String semesterName;
  final List<AcademicGradeResponse> academicGrades;

  const SemesterTranscriptResponse({
    required this.semesterName,
    required this.academicGrades,
  });

  static SemesterTranscriptResponse fromJson(String json) =>
      SemesterTranscriptResponseMapper.fromJson(json);

  static SemesterTranscriptResponse fromMap(Map<String, dynamic> map) =>
      SemesterTranscriptResponseMapper.fromMap(map);
}
