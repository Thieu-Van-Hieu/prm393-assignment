package prm393.se1911.assignment.myfschoolbackend.model.request;

public record LoginRequest(
        String phoneNumber,
        String password
) {
}
