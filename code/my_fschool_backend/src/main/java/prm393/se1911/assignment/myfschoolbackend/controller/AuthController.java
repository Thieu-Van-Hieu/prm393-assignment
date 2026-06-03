package prm393.se1911.assignment.myfschoolbackend.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import prm393.se1911.assignment.myfschoolbackend.entity.User;
import prm393.se1911.assignment.myfschoolbackend.exception.NotFoundException;
import prm393.se1911.assignment.myfschoolbackend.exception.UnauthorizedException;
import prm393.se1911.assignment.myfschoolbackend.model.request.ForgotPasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.LoginRequest;
import prm393.se1911.assignment.myfschoolbackend.service.AuthService;

import java.util.Map;
import java.util.Optional;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*", exposedHeaders = "X-Auth-Token")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request, HttpSession session) {

        // 1. Gọi xuống tầng Service xử lý nghiệp vụ
        Optional<User> userOptional = authService.authenticate(request);

        if (userOptional.isEmpty()) {
            throw new UnauthorizedException("Tài khoản hoặc mật khẩu không chính xác! Vui lòng thử lại.");
        }

        User user = userOptional.get();

        // 2. Đăng nhập đúng -> Lưu thông tin vào Session
        session.setAttribute("USER_ID", user.getId());
        session.setAttribute("USER_ROLE", user.getRole());

        // 3. Trả về thông tin cho Flutter
        return ResponseEntity.ok(Map.of(
                "userId", user.getId(),
                "fullName", user.getFullName(),
                "role", user.getRole()
        ));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody ForgotPasswordRequest forgotPasswordRequest) {
        String phoneNumber = forgotPasswordRequest.phoneNumber();

        // Kiểm tra tính hợp lệ của dữ liệu đầu vào
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Số điện thoại không được để trống! Vui lòng nhập lại.");
        }

        // Gọi sang Service xử lý logic reset và gửi tin nhắn
        boolean isResetSuccess = authService.resetPassword(phoneNumber);

        if (!isResetSuccess) {
            throw new NotFoundException("Số điện thoại không tồn tại trong hệ thống! Vui lòng kiểm tra lại.");
        }

        // Trả về thông báo thành công cho phía Flutter hiển thị Dialog
        return ResponseEntity.ok(Map.of(
                "message", "Mật khẩu mới gồm 6 chữ số đã được gửi trực tiếp qua SMS điện thoại của bạn!"
        ));
    }
}