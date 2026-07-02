import 'package:dart_mappable/dart_mappable.dart';

part 'event_property_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class EventPropertyResponse with EventPropertyResponseMappable {
  final String propertyName;
  final String propertyValue;

  EventPropertyResponse({
    required this.propertyName,
    required this.propertyValue,
  });

  static EventPropertyResponse fromJson(Map<String, dynamic> json) {
    return EventPropertyResponseMapper.fromMap(json);
  }

  static EventPropertyResponse fromMap(Map<String, dynamic> map) {
    return EventPropertyResponseMapper.fromMap(map);
  }
}
