import 'package:dart_mappable/dart_mappable.dart';

part 'event_registration_request.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.encode)
class EventRegistrationRequest with EventRegistrationRequestMappable {
  final String eventId;
  final int numberOfTickets;
  final String notes;

  EventRegistrationRequest({
    required this.eventId,
    required this.numberOfTickets,
    required this.notes,
  });
}
