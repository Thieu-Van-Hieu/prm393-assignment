package prm393.se1911.assignment.myfschoolbackend.service;

public interface OtpService {
    /**
     * Sinh mật khẩu ngẫu nhiên 6 số và kích hoạt gửi SMS qua Twilio
     *
     * @param phoneNumber Số điện thoại nhận tin nhắn
     * @return Chuỗi mật khẩu mới được sinh ra
     */
    String sendNewPasswordViaSms(String phoneNumber);
}