package mss301.se1911.group.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import mss301.se1911.group.assignment.myfschoolbackend.entity.User;
import mss301.se1911.group.assignment.myfschoolbackend.model.request.LoginRequest;
import mss301.se1911.group.assignment.myfschoolbackend.repository.UserRepository;
import mss301.se1911.group.assignment.myfschoolbackend.service.AuthService;
import mss301.se1911.group.assignment.myfschoolbackend.service.OtpService;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final OtpService otpService;

    @Override
    public Optional<User> authenticate(LoginRequest loginRequest) {
        Optional<User> userOptional = userRepository.findByPhoneNumber(loginRequest.phoneNumber());
        if (userOptional.isPresent() && userOptional.get().getPassword().equals(loginRequest.password())) {
            return userOptional;
        }
        return Optional.empty();
    }

    @Override
    public boolean resetPassword(String phoneNumber) {
        Optional<User> userOptional = userRepository.findByPhoneNumber(phoneNumber);

        if (userOptional.isEmpty()) {
            return false; // Trả về thất bại nếu số điện thoại không có trong DB
        }

        User user = userOptional.get();

        // 1. Gọi sang OtpService để sinh pass 6 số và gửi SMS ngầm
        String temporaryPassword = otpService.sendNewPasswordViaSms(phoneNumber);

        // 2. Lưu mật khẩu mới được sinh ra đè vào trường password hiện tại trong Database
        user.setPassword(temporaryPassword);
        userRepository.save(user);

        return true;
    }

    @Override
    public boolean changePassword(String userId, String oldPassword, String newPassword) {
        Optional<User> userOptional = userRepository.findById(UUID.fromString(userId));

        if (userOptional.isEmpty()) {
            return false; // Không tìm thấy User
        }

        User user = userOptional.get();

        // Kiểm tra mật khẩu cũ nhập vào có khớp với mật khẩu trong DB không
        if (!user.getPassword().equals(oldPassword)) {
            return false; // Mật khẩu cũ không chính xác
        }

        // Hợp lệ thì cập nhật mật khẩu mới
        user.setPassword(newPassword);
        userRepository.save(user);
        return true;
    }
}