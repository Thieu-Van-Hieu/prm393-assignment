package mss301.se1911.group.assignment.myfschoolbackend.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import mss301.se1911.group.assignment.myfschoolbackend.exception.UnauthorizedException;
import mss301.se1911.group.assignment.myfschoolbackend.model.request.ChangePasswordRequest;
import mss301.se1911.group.assignment.myfschoolbackend.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/user")
@RequiredArgsConstructor
public class UserController {

    private final AuthService authService;

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestBody ChangePasswordRequest changePasswordRequest, HttpSession session) {
        // Lấy USER_ID của ông phụ huynh đang đăng nhập từ Session (được Interceptor đảm bảo bảo mật)
        Object userIdObj = session.getAttribute("USER_ID");
        if (userIdObj == null) {
            throw new UnauthorizedException("Bạn phải đăng nhập để thực hiện hành động này!");
        }
        String userId = userIdObj.toString();

        String oldPassword = changePasswordRequest.oldPassword();
        String newPassword = changePasswordRequest.newPassword();

        if (oldPassword == null || newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng cung cấp mật khẩu cũ và mật khẩu mới hợp lệ!");
        }

        // Gọi xuống service xử lý kiểm tra và đổi pass
        boolean isSuccess = authService.changePassword(userId, oldPassword, newPassword);

        if (!isSuccess) {
            throw new IllegalArgumentException("Mật khẩu cũ không đúng hoặc người dùng không tồn tại! Vui lòng thử lại.");
        }

        return ResponseEntity.ok(Map.of("message", "Đổi mật khẩu thành công!"));
    }
}