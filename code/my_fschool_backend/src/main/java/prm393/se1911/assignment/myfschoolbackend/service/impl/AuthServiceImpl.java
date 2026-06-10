package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm393.se1911.assignment.myfschoolbackend.entity.User;
import prm393.se1911.assignment.myfschoolbackend.exception.NotFoundException;
import prm393.se1911.assignment.myfschoolbackend.exception.UnauthorizedException;
import prm393.se1911.assignment.myfschoolbackend.model.request.ChangePasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ForgotPasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.LoginRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.LoginResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.UserResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.UserRepository;
import prm393.se1911.assignment.myfschoolbackend.service.AuthService;
import prm393.se1911.assignment.myfschoolbackend.service.OtpService;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final OtpService otpService;

    @Override
    public LoginResponse authenticate(LoginRequest loginRequest) {
        Optional<User> userOptional = userRepository.findByPhoneNumber(loginRequest.phoneNumber());
        if (userOptional.isPresent() && userOptional.get().getPassword().equals(loginRequest.password())) {
            User user = userOptional.get();
            return LoginResponse.builder()
                    .userId(user.getId())
                    .fullName(user.getFullName())
                    .role(user.getRole())
                    .build();
        }
        throw new UnauthorizedException("Tài khoản hoặc mật khẩu không chính xác! Vui lòng thử lại.");
    }

    @Override
    public void resetPassword(ForgotPasswordRequest forgotPasswordRequest) {
        String phoneNumber = forgotPasswordRequest.phoneNumber();

        // Kiểm tra tính hợp lệ của dữ liệu đầu vào
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Số điện thoại không được để trống! Vui lòng nhập lại.");
        }

        Optional<User> userOptional = userRepository.findByPhoneNumber(phoneNumber);

        if (userOptional.isEmpty()) {
            throw new NotFoundException("Số điện thoại không tồn tại trong hệ thống! Vui lòng kiểm tra lại.");
        }

        User user = userOptional.get();

        String temporaryPassword = otpService.sendNewPasswordViaSms(phoneNumber);

        user.setPassword(temporaryPassword);
        userRepository.save(user);
    }

    @Override
    public void changePassword(String userId, ChangePasswordRequest changePasswordRequest) {

        String oldPassword = changePasswordRequest.oldPassword();
        String newPassword = changePasswordRequest.newPassword();

        if (oldPassword == null || newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng cung cấp mật khẩu cũ và mật khẩu mới hợp lệ!");
        }

        Optional<User> userOptional = userRepository.findById(UUID.fromString(userId));

        if (userOptional.isEmpty()) {
            throw new IllegalArgumentException("Người dùng không tồn tại! Vui lòng đăng nhập lại.");
        }

        User user = userOptional.get();

        // Kiểm tra mật khẩu cũ nhập vào có khớp với mật khẩu trong DB không
        if (!user.getPassword().equals(oldPassword)) {
            throw new IllegalArgumentException("Mật khẩu cũ không đúng hoặc người dùng không tồn tại! Vui lòng thử lại.");
        }

        // Hợp lệ thì cập nhật mật khẩu mới
        user.setPassword(newPassword);
        userRepository.save(user);
    }

    @Override
    public UserResponse findById(UUID id) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isEmpty()) {
            throw new NotFoundException("Không tìm thấy thông tin người dùng! Vui lòng đăng nhập lại.");
        }
        User user = userOptional.get();
        return UserResponse.builder()
                .fullName(user.getFullName())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .roleName(user.getRole())
                .build();
    }
}