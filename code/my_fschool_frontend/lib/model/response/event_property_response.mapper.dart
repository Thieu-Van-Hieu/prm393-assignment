// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'event_property_response.dart';

class EventPropertyResponseMapper
    extends ClassMapperBase<EventPropertyResponse> {
  EventPropertyResponseMapper._();

  static EventPropertyResponseMapper? _instance;
  static EventPropertyResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EventPropertyResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EventPropertyResponse';

  static String _$propertyName(EventPropertyResponse v) => v.propertyName;
  static const Field<EventPropertyResponse, String> _f$propertyName = Field(
    'propertyName',
    _$propertyName,
  );
  static String _$propertyValue(EventPropertyResponse v) => v.propertyValue;
  static const Field<EventPropertyResponse, String> _f$propertyValue = Field(
    'propertyValue',
    _$propertyValue,
  );

  @override
  final MappableFields<EventPropertyResponse> fields = const {
    #propertyName: _f$propertyName,
    #propertyValue: _f$propertyValue,
  };

  static EventPropertyResponse _instantiate(DecodingData data) {
    return EventPropertyResponse(
      propertyName: data.dec(_f$propertyName),
      propertyValue: data.dec(_f$propertyValue),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EventPropertyResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EventPropertyResponse>(map);
  }

  static EventPropertyResponse fromJson(String json) {
    return ensureInitialized().decodeJson<EventPropertyResponse>(json);
  }
}

mixin EventPropertyResponseMappable {}

