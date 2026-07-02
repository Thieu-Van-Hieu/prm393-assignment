package prm393.se1911.assignment.myfschoolbackend.util;

import jakarta.servlet.http.HttpSession;
import prm393.se1911.assignment.myfschoolbackend.exception.UnauthorizedException;

import java.util.UUID;

public class SessionUtils {
    public static UUID getUserIdFromSession(HttpSession session) {
        Object userIdObj = session.getAttribute("USER_ID");
        if (userIdObj == null) {
            throw new UnauthorizedException("Bạn phải đăng nhập để thực hiện hành động này!");
        }
        return UUID.fromString(userIdObj.toString());
    }
}
