package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.util.UUID;

@Builder
public record ClubResponse(
        UUID id,
        String clubName,
        String description,
        String base64Image,
        String schedules
) {
}