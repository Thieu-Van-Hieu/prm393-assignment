package mss301.se1911.group.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.util.UUID;

@Builder
public record LoginResponse(UUID userId, String fullName, String role) {
}
