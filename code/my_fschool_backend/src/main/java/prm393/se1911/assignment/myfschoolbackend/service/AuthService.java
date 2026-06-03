package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.entity.User;
import prm393.se1911.assignment.myfschoolbackend.model.request.LoginRequest;

import java.util.Optional;

public interface AuthService {
    Optional<User> authenticate(LoginRequest loginRequest);

    boolean resetPassword(String phoneNumber);

    boolean changePassword(String userId, String oldPassword, String newPassword);
}