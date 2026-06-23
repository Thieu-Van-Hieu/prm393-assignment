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

mixin AcademicGradeResponseMappable {
  String toJson() {
    return AcademicGradeResponseMapper.ensureInitialized()
        .encodeJson<AcademicGradeResponse>(this as AcademicGradeResponse);
  }

  Map<String, dynamic> toMap() {
    return AcademicGradeResponseMapper.ensureInitialized()
        .encodeMap<AcademicGradeResponse>(this as AcademicGradeResponse);
  }

  AcademicGradeResponseCopyWith<
    AcademicGradeResponse,
    AcademicGradeResponse,
    AcademicGradeResponse
  >
  get copyWith =>
      _AcademicGradeResponseCopyWithImpl<
        AcademicGradeResponse,
        AcademicGradeResponse
      >(this as AcademicGradeResponse, $identity, $identity);
  @override
  String toString() {
    return AcademicGradeResponseMapper.ensureInitialized().stringifyValue(
      this as AcademicGradeResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return AcademicGradeResponseMapper.ensureInitialized().equalsValue(
      this as AcademicGradeResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return AcademicGradeResponseMapper.ensureInitialized().hashValue(
      this as AcademicGradeResponse,
    );
  }
}

extension AcademicGradeResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AcademicGradeResponse, $Out> {
  AcademicGradeResponseCopyWith<$R, AcademicGradeResponse, $Out>
  get $asAcademicGradeResponse => $base.as(
    (v, t, t2) => _AcademicGradeResponseCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AcademicGradeResponseCopyWith<
  $R,
  $In extends AcademicGradeResponse,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get regularScores;
  $R call({
    String? subjectName,
    SubjectType? type,
    List<int>? regularScores,
    double? midTermScore,
    double? finalTermScore,
    double? summaryScore,
    String? qualitativeResult,
    String? teacherComment,
  });
  AcademicGradeResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AcademicGradeResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AcademicGradeResponse, $Out>
    implements AcademicGradeResponseCopyWith<$R, AcademicGradeResponse, $Out> {
  _AcademicGradeResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AcademicGradeResponse> $mapper =
      AcademicGradeResponseMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get regularScores =>
      $value.regularScores != null
      ? ListCopyWith(
          $value.regularScores!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(regularScores: v),
        )
      : null;
  @override
  $R call({
    String? subjectName,
    SubjectType? type,
    Object? regularScores = $none,
    Object? midTermScore = $none,
    Object? finalTermScore = $none,
    Object? summaryScore = $none,
    Object? qualitativeResult = $none,
    String? teacherComment,
  }) => $apply(
    FieldCopyWithData({
      if (subjectName != null) #subjectName: subjectName,
      if (type != null) #type: type,
      if (regularScores != $none) #regularScores: regularScores,
      if (midTermScore != $none) #midTermScore: midTermScore,
      if (finalTermScore != $none) #finalTermScore: finalTermScore,
      if (summaryScore != $none) #summaryScore: summaryScore,
      if (qualitativeResult != $none) #qualitativeResult: qualitativeResult,
      if (teacherComment != null) #teacherComment: teacherComment,
    }),
  );
  @override
  AcademicGradeResponse $make(CopyWithData data) => AcademicGradeResponse(
    subjectName: data.get(#subjectName, or: $value.subjectName),
    type: data.get(#type, or: $value.type),
    regularScores: data.get(#regularScores, or: $value.regularScores),
    midTermScore: data.get(#midTermScore, or: $value.midTermScore),
    finalTermScore: data.get(#finalTermScore, or: $value.finalTermScore),
    summaryScore: data.get(#summaryScore, or: $value.summaryScore),
    qualitativeResult: data.get(
      #qualitativeResult,
      or: $value.qualitativeResult,
    ),
    teacherComment: data.get(#teacherComment, or: $value.teacherComment),
  );

  @override
  AcademicGradeResponseCopyWith<$R2, AcademicGradeResponse, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AcademicGradeResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

