package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

@Builder
public record UserResponse(String fullName, String phoneNumber, String email, String roleName) {
}
