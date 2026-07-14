package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Builder
public record EventResponse(
        UUID id,
        String badge,
        String title,
        String base64Image,
        String description,
        Instant createdAt,
        boolean isRegistered,
        List<EventPropertyResponse> eventProperties
) {
}
