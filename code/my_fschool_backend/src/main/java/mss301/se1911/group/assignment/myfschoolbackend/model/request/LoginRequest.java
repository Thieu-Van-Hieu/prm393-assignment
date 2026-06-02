package mss301.se1911.group.assignment.myfschoolbackend.model.request;

public record LoginRequest(
        String phoneNumber,
        String password
) {
}
