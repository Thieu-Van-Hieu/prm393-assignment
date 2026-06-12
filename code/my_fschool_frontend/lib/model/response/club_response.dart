import 'package:dart_mappable/dart_mappable.dart';

part 'club_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class ClubResponse with ClubResponseMappable {
  String id;
  String clubName;
  String? schedules;

  ClubResponse({required this.id, required this.clubName, this.schedules});

  factory ClubResponse.fromJson(String json) =>
      ClubResponseMapper.fromJson(json);

  factory ClubResponse.fromMap(Map<String, dynamic> map) =>
      ClubResponseMapper.fromMap(map);
}
