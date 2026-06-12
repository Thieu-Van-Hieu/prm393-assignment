// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'club_response.dart';

class ClubResponseMapper extends ClassMapperBase<ClubResponse> {
  ClubResponseMapper._();

  static ClubResponseMapper? _instance;
  static ClubResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ClubResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ClubResponse';

  static String _$id(ClubResponse v) => v.id;
  static const Field<ClubResponse, String> _f$id = Field('id', _$id);
  static String _$clubName(ClubResponse v) => v.clubName;
  static const Field<ClubResponse, String> _f$clubName = Field(
    'clubName',
    _$clubName,
  );
  static String? _$schedules(ClubResponse v) => v.schedules;
  static const Field<ClubResponse, String> _f$schedules = Field(
    'schedules',
    _$schedules,
    opt: true,
  );

  @override
  final MappableFields<ClubResponse> fields = const {
    #id: _f$id,
    #clubName: _f$clubName,
    #schedules: _f$schedules,
  };

  static ClubResponse _instantiate(DecodingData data) {
    return ClubResponse(
      id: data.dec(_f$id),
      clubName: data.dec(_f$clubName),
      schedules: data.dec(_f$schedules),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ClubResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ClubResponse>(map);
  }

  static ClubResponse fromJson(String json) {
    return ensureInitialized().decodeJson<ClubResponse>(json);
  }
}

mixin ClubResponseMappable {}

