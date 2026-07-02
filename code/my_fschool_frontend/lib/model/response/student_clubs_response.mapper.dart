// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'student_clubs_response.dart';

class StudentClubsResponseMapper extends ClassMapperBase<StudentClubsResponse> {
  StudentClubsResponseMapper._();

  static StudentClubsResponseMapper? _instance;
  static StudentClubsResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudentClubsResponseMapper._());
      ClubResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StudentClubsResponse';

  static List<ClubResponse> _$joinedClubs(StudentClubsResponse v) =>
      v.joinedClubs;
  static const Field<StudentClubsResponse, List<ClubResponse>> _f$joinedClubs =
      Field('joinedClubs', _$joinedClubs);
  static List<ClubResponse> _$unjoinedClubs(StudentClubsResponse v) =>
      v.unjoinedClubs;
  static const Field<StudentClubsResponse, List<ClubResponse>>
  _f$unjoinedClubs = Field('unjoinedClubs', _$unjoinedClubs);

  @override
  final MappableFields<StudentClubsResponse> fields = const {
    #joinedClubs: _f$joinedClubs,
    #unjoinedClubs: _f$unjoinedClubs,
  };

  static StudentClubsResponse _instantiate(DecodingData data) {
    return StudentClubsResponse(
      joinedClubs: data.dec(_f$joinedClubs),
      unjoinedClubs: data.dec(_f$unjoinedClubs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StudentClubsResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudentClubsResponse>(map);
  }

  static StudentClubsResponse fromJson(String json) {
    return ensureInitialized().decodeJson<StudentClubsResponse>(json);
  }
}

mixin StudentClubsResponseMappable {}

