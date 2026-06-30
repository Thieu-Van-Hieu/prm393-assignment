// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'academic_grade_response.dart';

class AcademicGradeResponseMapper
    extends ClassMapperBase<AcademicGradeResponse> {
  AcademicGradeResponseMapper._();

  static AcademicGradeResponseMapper? _instance;
  static AcademicGradeResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AcademicGradeResponseMapper._());
      SubjectTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AcademicGradeResponse';

  static String _$subjectName(AcademicGradeResponse v) => v.subjectName;
  static const Field<AcademicGradeResponse, String> _f$subjectName = Field(
    'subjectName',
    _$subjectName,
  );
  static SubjectType _$type(AcademicGradeResponse v) => v.type;
  static const Field<AcademicGradeResponse, SubjectType> _f$type = Field(
    'type',
    _$type,
  );
  static List<int>? _$regularScores(AcademicGradeResponse v) => v.regularScores;
  static const Field<AcademicGradeResponse, List<int>> _f$regularScores = Field(
    'regularScores',
    _$regularScores,
    opt: true,
  );
  static double? _$midTermScore(AcademicGradeResponse v) => v.midTermScore;
  static const Field<AcademicGradeResponse, double> _f$midTermScore = Field(
    'midTermScore',
    _$midTermScore,
    opt: true,
  );
  static double? _$finalTermScore(AcademicGradeResponse v) => v.finalTermScore;
  static const Field<AcademicGradeResponse, double> _f$finalTermScore = Field(
    'finalTermScore',
    _$finalTermScore,
    opt: true,
  );
  static double? _$summaryScore(AcademicGradeResponse v) => v.summaryScore;
  static const Field<AcademicGradeResponse, double> _f$summaryScore = Field(
    'summaryScore',
    _$summaryScore,
    opt: true,
  );
  static String? _$qualitativeResult(AcademicGradeResponse v) =>
      v.qualitativeResult;
  static const Field<AcademicGradeResponse, String> _f$qualitativeResult =
      Field('qualitativeResult', _$qualitativeResult, opt: true);
  static String _$teacherComment(AcademicGradeResponse v) => v.teacherComment;
  static const Field<AcademicGradeResponse, String> _f$teacherComment = Field(
    'teacherComment',
    _$teacherComment,
  );

  @override
  final MappableFields<AcademicGradeResponse> fields = const {
    #subjectName: _f$subjectName,
    #type: _f$type,
    #regularScores: _f$regularScores,
    #midTermScore: _f$midTermScore,
    #finalTermScore: _f$finalTermScore,
    #summaryScore: _f$summaryScore,
    #qualitativeResult: _f$qualitativeResult,
    #teacherComment: _f$teacherComment,
  };

  static AcademicGradeResponse _instantiate(DecodingData data) {
    return AcademicGradeResponse(
      subjectName: data.dec(_f$subjectName),
      type: data.dec(_f$type),
      regularScores: data.dec(_f$regularScores),
      midTermScore: data.dec(_f$midTermScore),
      finalTermScore: data.dec(_f$finalTermScore),
      summaryScore: data.dec(_f$summaryScore),
      qualitativeResult: data.dec(_f$qualitativeResult),
      teacherComment: data.dec(_f$teacherComment),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AcademicGradeResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AcademicGradeResponse>(map);
  }

  static AcademicGradeResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AcademicGradeResponse>(json);
  }
}

mixin AcademicGradeResponseMappable {}

