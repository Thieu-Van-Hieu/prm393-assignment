// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'semester_transcript_response.dart';

class SemesterTranscriptResponseMapper
    extends ClassMapperBase<SemesterTranscriptResponse> {
  SemesterTranscriptResponseMapper._();

  static SemesterTranscriptResponseMapper? _instance;
  static SemesterTranscriptResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SemesterTranscriptResponseMapper._(),
      );
      AcademicGradeResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SemesterTranscriptResponse';

  static String _$semesterName(SemesterTranscriptResponse v) => v.semesterName;
  static const Field<SemesterTranscriptResponse, String> _f$semesterName =
      Field('semesterName', _$semesterName);
  static List<AcademicGradeResponse> _$academicGrades(
    SemesterTranscriptResponse v,
  ) => v.academicGrades;
  static const Field<SemesterTranscriptResponse, List<AcademicGradeResponse>>
  _f$academicGrades = Field('academicGrades', _$academicGrades);

  @override
  final MappableFields<SemesterTranscriptResponse> fields = const {
    #semesterName: _f$semesterName,
    #academicGrades: _f$academicGrades,
  };

  static SemesterTranscriptResponse _instantiate(DecodingData data) {
    return SemesterTranscriptResponse(
      semesterName: data.dec(_f$semesterName),
      academicGrades: data.dec(_f$academicGrades),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SemesterTranscriptResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SemesterTranscriptResponse>(map);
  }

  static SemesterTranscriptResponse fromJson(String json) {
    return ensureInitialized().decodeJson<SemesterTranscriptResponse>(json);
  }
}

mixin SemesterTranscriptResponseMappable {}

