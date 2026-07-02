// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'event_registration_request.dart';

class EventRegistrationRequestMapper
    extends ClassMapperBase<EventRegistrationRequest> {
  EventRegistrationRequestMapper._();

  static EventRegistrationRequestMapper? _instance;
  static EventRegistrationRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = EventRegistrationRequestMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'EventRegistrationRequest';

  static String _$eventId(EventRegistrationRequest v) => v.eventId;
  static const Field<EventRegistrationRequest, String> _f$eventId = Field(
    'eventId',
    _$eventId,
  );
  static int _$numberOfTickets(EventRegistrationRequest v) => v.numberOfTickets;
  static const Field<EventRegistrationRequest, int> _f$numberOfTickets = Field(
    'numberOfTickets',
    _$numberOfTickets,
  );
  static String _$notes(EventRegistrationRequest v) => v.notes;
  static const Field<EventRegistrationRequest, String> _f$notes = Field(
    'notes',
    _$notes,
  );

  @override
  final MappableFields<EventRegistrationRequest> fields = const {
    #eventId: _f$eventId,
    #numberOfTickets: _f$numberOfTickets,
    #notes: _f$notes,
  };

  static EventRegistrationRequest _instantiate(DecodingData data) {
    return EventRegistrationRequest(
      eventId: data.dec(_f$eventId),
      numberOfTickets: data.dec(_f$numberOfTickets),
      notes: data.dec(_f$notes),
    );
  }

  @override
  final Function instantiate = _instantiate;
}

mixin EventRegistrationRequestMappable {
  String toJson() {
    return EventRegistrationRequestMapper.ensureInitialized()
        .encodeJson<EventRegistrationRequest>(this as EventRegistrationRequest);
  }

  Map<String, dynamic> toMap() {
    return EventRegistrationRequestMapper.ensureInitialized()
        .encodeMap<EventRegistrationRequest>(this as EventRegistrationRequest);
  }
}

