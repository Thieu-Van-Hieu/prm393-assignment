package mss301.se1911.group.assignment.myfschoolbackend.service;

import mss301.se1911.group.assignment.myfschoolbackend.entity.User;
import mss301.se1911.group.assignment.myfschoolbackend.model.request.LoginRequest;

import java.util.Optional;

public interface AuthService {
    Optional<User> authenticate(LoginRequest loginRequest);

    boolean resetPassword(String phoneNumber);

    boolean changePassword(String userId, String oldPassword, String newPassword);
}