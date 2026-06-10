package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.request.ChangePasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ForgotPasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.LoginRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.LoginResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.UserResponse;

import java.util.UUID;

public interface AuthService {
    LoginResponse authenticate(LoginRequest loginRequest);

    UserResponse findById(UUID id);

    void resetPassword(ForgotPasswordRequest forgotPasswordRequest);

    void changePassword(String userId, ChangePasswordRequest changePasswordRequest);
}