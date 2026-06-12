// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'class_response.dart';

class ClassResponseMapper extends ClassMapperBase<ClassResponse> {
  ClassResponseMapper._();

  static ClassResponseMapper? _instance;
  static ClassResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ClassResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ClassResponse';

  static String _$id(ClassResponse v) => v.id;
  static const Field<ClassResponse, String> _f$id = Field('id', _$id);
  static String _$className(ClassResponse v) => v.className;
  static const Field<ClassResponse, String> _f$className = Field(
    'className',
    _$className,
  );
  static String _$schoolYear(ClassResponse v) => v.schoolYear;
  static const Field<ClassResponse, String> _f$schoolYear = Field(
    'schoolYear',
    _$schoolYear,
  );

  @override
  final MappableFields<ClassResponse> fields = const {
    #id: _f$id,
    #className: _f$className,
    #schoolYear: _f$schoolYear,
  };

  static ClassResponse _instantiate(DecodingData data) {
    return ClassResponse(
      id: data.dec(_f$id),
      className: data.dec(_f$className),
      schoolYear: data.dec(_f$schoolYear),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ClassResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ClassResponse>(map);
  }

  static ClassResponse fromJson(String json) {
    return ensureInitialized().decodeJson<ClassResponse>(json);
  }
}

mixin ClassResponseMappable {}

