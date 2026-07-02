package prm393.se1911.assignment.myfschoolbackend.model.request;

import lombok.Builder;

import java.util.UUID;

@Builder
public record EventRegistrationRequest(
        UUID eventId,
        Integer numberOfAttendees,
        String notes
) {
}
