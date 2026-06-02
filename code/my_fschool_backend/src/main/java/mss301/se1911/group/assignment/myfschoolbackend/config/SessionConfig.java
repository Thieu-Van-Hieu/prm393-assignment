package mss301.se1911.group.assignment.myfschoolbackend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.session.web.http.HeaderHttpSessionIdResolver;
import org.springframework.session.web.http.HttpSessionIdResolver;

@Configuration
public class SessionConfig {

    @Bean
    public HttpSessionIdResolver httpSessionIdResolver() {
        // Biến đổi Session từ Cookie thành Header tên là "X-Auth-Token"
        return HeaderHttpSessionIdResolver.xAuthToken();
    }
}
