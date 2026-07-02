package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm393.se1911.assignment.myfschoolbackend.entity.Event;
import prm393.se1911.assignment.myfschoolbackend.entity.EventRegistration;
import prm393.se1911.assignment.myfschoolbackend.model.request.EventRegistrationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.EventPropertyResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.EventResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.EventRegistrationRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.EventRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.UserRepository;
import prm393.se1911.assignment.myfschoolbackend.service.EventService;
import prm393.se1911.assignment.myfschoolbackend.util.TimestampUtils;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class EventServiceImpl implements EventService {

    private final EventRepository eventRepository;
    private final EventRegistrationRepository eventRegistrationRepository;
    private final UserRepository userRepository;

    private List<EventPropertyResponse> toEventPropertyResponseList(Event event) {
        return event.getEventProperties().stream()
                .map(property -> EventPropertyResponse.builder()
                        .propertyName(property.getPropertyName())
                        .propertyValue(property.getPropertyValue())
                        .build())
                .toList();
    }

    @Override
    public List<EventResponse> getAllEvents() {
        return eventRepository.findAll()
                .stream().map(event -> EventResponse.builder()
                        .id(event.getId())
                        .badge(event.getBadge())
                        .title(event.getTitle())
                        .base64Image(event.getBase64Image())
                        .description(event.getDescription())
                        .eventProperties(toEventPropertyResponseList(event))
                        .build())
                .toList();
    }

    @Override
    public void registerEvent(UUID parentId, EventRegistrationRequest request) {
        // Ktra xem phụ huynh này đã đăng ký ch
        final var existedRegistration = eventRegistrationRepository.findByParentIdAndEventId(parentId, request.eventId());
        if (existedRegistration != null) {
            throw new RuntimeException("Phụ huynh đã đăng ký sự kiện này rồi");
        }

        final var event = eventRepository.findById(request.eventId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự kiện"));
        final var parent = userRepository.findById(parentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phụ huynh"));
        final var registration = new EventRegistration();
        registration.setEvent(event);
        registration.setParent(parent);
        registration.setNumberOfAttendees(request.numberOfAttendees());
        registration.setNotes(request.notes());
        registration.setRegisteredAt(TimestampUtils.getCurrentTimestamp());
        eventRegistrationRepository.save(registration);
    }
}
