package mss301.se1911.group.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import mss301.se1911.group.assignment.myfschoolbackend.service.OtpService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class OtpServiceImpl implements OtpService {

    private final RestTemplate restTemplate;
    @Value("${speedsms.access-token}")
    private String accessToken;
    @Value("${speedsms.device-id}")
    private String deviceId;

    @Override
    public String sendNewPasswordViaSms(String phoneNumber) {
        String newPassword = String.valueOf((int) ((Math.random() * 900000) + 100000));
        String apiUrl = "https://api.speedsms.vn/index.php/sms/send";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String auth = accessToken + ":";
        String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
        headers.set("Authorization", "Basic " + encodedAuth);

        // Chuẩn hóa số điện thoại dạng 84... cho hệ thống
        String formattedPhone = phoneNumber;
        if (phoneNumber.startsWith("0")) {
            formattedPhone = "84" + phoneNumber.substring(1);
        }

        // Bỏ đoạn &type=2 đi là xong phen nhé
        String smsContent = "FSchool - Mat khau moi dang nhap cua ban la: " + newPassword;

        // Đóng gói JSON theo cấu hình SMS Gateway Android
        Map<String, Object> body = new HashMap<>();
        body.put("to", List.of(formattedPhone));
        body.put("content", smsContent);
        body.put("sms_type", 5); // ĐỔI SÀNG 5: Gửi bằng App Android Gateway
        body.put("sender", deviceId.trim()); // TRUYỀN ĐÚNG DEVICE ID VÀO ĐÂY

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(apiUrl, requestEntity, Map.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                System.out.println("======> SMS GATEWAY RESPONSE: " + response.getBody());
            }
        } catch (Exception e) {
            System.err.println("Lỗi gọi API SMS Gateway: " + e.getMessage());
        }

        System.out.println("======> SMS GATEWAY TRIGGERED | PHONE: " + phoneNumber + " | PASSWORD: " + newPassword);
        return newPassword;
    }
}