package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.util.UUID;

@Builder
public record EventPropertyResponse(
        UUID id,
        String propertyName,
        String propertyValue
) {
}
