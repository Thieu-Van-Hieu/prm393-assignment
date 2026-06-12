package prm393.se1911.assignment.myfschoolbackend.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import prm393.se1911.assignment.myfschoolbackend.exception.UnauthorizedException;
import prm393.se1911.assignment.myfschoolbackend.model.request.ChangePasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ForgotPasswordRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.LoginRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.LoginResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.UserResponse;
import prm393.se1911.assignment.myfschoolbackend.service.AuthService;
import prm393.se1911.assignment.myfschoolbackend.service.UserService;

import java.util.Map;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*", exposedHeaders = "X-Auth-Token")
public class AuthController {

    private final AuthService authService;
    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request, HttpSession session) {

        // 1. Gọi xuống tầng Service xử lý nghiệp vụ
        LoginResponse loginResponse = authService.authenticate(request);

        // 2. Đăng nhập đúng -> Lưu thông tin vào Session
        session.setAttribute("USER_ID", loginResponse.userId());
        session.setAttribute("USER_ROLE", loginResponse.role());

        // 3. Trả về thông tin cho Flutter
        return ResponseEntity.ok(loginResponse);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody ForgotPasswordRequest forgotPasswordRequest) {

        // Gọi sang Service xử lý logic reset và gửi tin nhắn
        authService.resetPassword(forgotPasswordRequest);

        // Trả về thông báo thành công cho phía Flutter hiển thị Dialog
        return ResponseEntity.ok(Map.of(
                "message", "Mật khẩu mới gồm 6 chữ số đã được gửi trực tiếp qua SMS điện thoại của bạn!"
        ));
    }

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestBody ChangePasswordRequest changePasswordRequest, HttpSession session) {
        // Lấy USER_ID của ông phụ huynh đang đăng nhập từ Session (được Interceptor đảm bảo bảo mật)
        Object userIdObj = session.getAttribute("USER_ID");
        if (userIdObj == null) {
            throw new UnauthorizedException("Bạn phải đăng nhập để thực hiện hành động này!");
        }
        String userId = userIdObj.toString();

        // Gọi xuống service xử lý kiểm tra và đổi pass
        authService.changePassword(userId, changePasswordRequest);

        return ResponseEntity.ok(Map.of("message", "Đổi mật khẩu thành công!"));
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(HttpSession session) {
        Object userIdObj = session.getAttribute("USER_ID");
        if (userIdObj == null) {
            throw new UnauthorizedException("Bạn phải đăng nhập để thực hiện hành động này!");
        }
        String userId = userIdObj.toString();

        UserResponse userResponse = userService.getUserContext(UUID.fromString(userId));

        return ResponseEntity.ok(userResponse);
    }
}