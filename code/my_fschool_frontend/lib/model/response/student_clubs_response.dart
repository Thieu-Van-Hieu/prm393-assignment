import 'package:dart_mappable/dart_mappable.dart';
import 'package:my_fschool_frontend/model/response/club_response.dart';

part 'student_clubs_response.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class StudentClubsResponse with StudentClubsResponseMappable {
  final List<ClubResponse> joinedClubs;
  final List<ClubResponse> unjoinedClubs;

  StudentClubsResponse({
    required this.joinedClubs,
    required this.unjoinedClubs,
  });

  static StudentClubsResponse fromMap(Map<String, dynamic> map) {
    return StudentClubsResponseMapper.fromMap(map);
  }

  static StudentClubsResponse fromJson(String json) {
    return StudentClubsResponseMapper.fromJson(json);
  }
}
