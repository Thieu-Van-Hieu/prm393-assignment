package prm393.se1911.assignment.myfschoolbackend.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@RequiredArgsConstructor
@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final prm393.se1911.assignment.myfschoolbackend.config.AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Áp dụng lớp bọc này cho tất cả các API, trừ luồng login/auth
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/api/v1/**")
                .excludePathPatterns("/api/v1/auth/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // Áp dụng cho tất cả các API url
                .allowedOrigins("*") // Cho phép tất cả các nguồn (Flutter Web, Emulator, Postman) gọi tới
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // Các method được phép
                .allowedHeaders("*") // Chấp nhận mọi Header gửi lên
                .exposedHeaders("X-Auth-Token"); // BẮT BUỘC: Cho phép Frontend (Flutter) nhìn thấy và đọc được Header này
    }
}