// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'event_response.dart';

class EventResponseMapper extends ClassMapperBase<EventResponse> {
  EventResponseMapper._();

  static EventResponseMapper? _instance;
  static EventResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EventResponseMapper._());
      EventPropertyResponseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EventResponse';

  static String _$id(EventResponse v) => v.id;
  static const Field<EventResponse, String> _f$id = Field('id', _$id);
  static String _$badge(EventResponse v) => v.badge;
  static const Field<EventResponse, String> _f$badge = Field('badge', _$badge);
  static String _$title(EventResponse v) => v.title;
  static const Field<EventResponse, String> _f$title = Field('title', _$title);
  static String? _$base64Image(EventResponse v) => v.base64Image;
  static const Field<EventResponse, String> _f$base64Image = Field(
    'base64Image',
    _$base64Image,
    opt: true,
  );
  static String? _$description(EventResponse v) => v.description;
  static const Field<EventResponse, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isRegistered(EventResponse v) => v.isRegistered;
  static const Field<EventResponse, bool> _f$isRegistered = Field(
    'isRegistered',
    _$isRegistered,
  );
  static List<EventPropertyResponse> _$eventProperties(EventResponse v) =>
      v.eventProperties;
  static const Field<EventResponse, List<EventPropertyResponse>>
  _f$eventProperties = Field('eventProperties', _$eventProperties);

  @override
  final MappableFields<EventResponse> fields = const {
    #id: _f$id,
    #badge: _f$badge,
    #title: _f$title,
    #base64Image: _f$base64Image,
    #description: _f$description,
    #isRegistered: _f$isRegistered,
    #eventProperties: _f$eventProperties,
  };

  static EventResponse _instantiate(DecodingData data) {
    return EventResponse(
      id: data.dec(_f$id),
      badge: data.dec(_f$badge),
      title: data.dec(_f$title),
      base64Image: data.dec(_f$base64Image),
      description: data.dec(_f$description),
      isRegistered: data.dec(_f$isRegistered),
      eventProperties: data.dec(_f$eventProperties),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EventResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EventResponse>(map);
  }

  static EventResponse fromJson(String json) {
    return ensureInitialized().decodeJson<EventResponse>(json);
  }
}

mixin EventResponseMappable {}

