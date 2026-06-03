package prm393.se1911.assignment.myfschoolbackend.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.jspecify.annotations.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.HandlerInterceptor;
import prm393.se1911.assignment.myfschoolbackend.exception.UnauthorizedException;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Autowired
    @Qualifier("handlerExceptionResolver")
    @Lazy
    private HandlerExceptionResolver resolver;

    @Override
    public boolean preHandle(HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull Object handler) {
        // Bypass cho các API không cần đăng nhập (như Login, Forgot Password)
        if (request.getRequestURI().contains("/api/v1/auth/")) {
            return true;
        }

        // Tự động lấy Session từ Header X-Auth-Token (Spring Session xử lý ngầm)
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER_ID") == null) {
            // Dùng resolver để "ném" Exception sang cho ControllerAdvice xử lý hộ
            resolver.resolveException(request, response, handler,
                    new UnauthorizedException("Phiên làm việc hết hạn. Vui lòng đăng nhập lại!"));
            return false; // Ngăn không cho đi tiếp vào Controller
        }

        return true; // Session hợp lệ, cho phép đi tiếp vào Controller
    }
}
