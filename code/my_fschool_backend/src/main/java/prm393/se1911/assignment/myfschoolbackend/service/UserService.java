package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.response.UserResponse;

import java.util.UUID;

public interface UserService {
    UserResponse getUserContext(UUID userId);
}
