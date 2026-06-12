package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.request.ChangePasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ForgotPasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.LoginRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.LoginResponse;

public interface AuthService {
    LoginResponse authenticate(LoginRequest loginRequest);

    void resetPassword(ForgotPasswordRequest forgotPasswordRequest);

    void changePassword(String userId, ChangePasswordRequest changePasswordRequest);
}