package prm393.se1911.assignment.myfschoolbackend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Configuration;

import javax.jmdns.JmDNS;
import javax.jmdns.ServiceInfo;
import java.io.IOException;
import java.net.InetAddress;

@Configuration
public class MdnsRegistrationConfig implements ApplicationListener<ApplicationReadyEvent> {

    // Tự động lấy cổng từ cấu hình của Spring Boot, mặc định là 8080 nếu không khai báo
    @Value("${server.port:8080}")
    private int serverPort;

    private JmDNS jmdns;

    @Override
    public void onApplicationEvent(ApplicationReadyEvent event) {
        try {
            // Lấy địa chỉ IP mạng nội bộ hiện tại của máy tính chạy Spring Boot
            InetAddress localHost = InetAddress.getLocalHost();

            // Khởi tạo thực thể JmDNS gắn với IP hiện tại
            jmdns = JmDNS.create(localHost);

            // Đăng ký dịch vụ mDNS:
            // - Tham số 1: Định dạng service type chuẩn mDNS/DNS-SD (luôn kết thúc bằng .local.)
            // - Tham số 2: Tên hiển thị của dịch vụ
            // - Tham số 3: Port chạy backend (8080)
            // - Tham số 4: Mô tả thêm hoặc đường dẫn gốc
            ServiceInfo serviceInfo = ServiceInfo.create(
                    "_http._tcp.local.",
                    "fschool-backend", // Bạn có thể đặt tên tùy ý
                    serverPort,
                    "path=/api/v1"
            );

            jmdns.registerService(serviceInfo);

            System.out.println("==================================================");
            System.out.println("🚀 mDNS Service registered successfully!");
            System.out.println("📍 Service Name: " + serviceInfo.getName());
            System.out.println("📍 Local Host IP: " + localHost.getHostAddress());
            System.out.println("📍 Domain: fschool-backend.local:" + serverPort);
            System.out.println("==================================================");

        } catch (IOException e) {
            System.err.println("❌ Failed to register mDNS service: " + e.getMessage());
            e.printStackTrace();
        }

        // Đảm bảo đóng kết nối mDNS khi ứng dụng Spring Boot bị tắt (Shutdown)
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            if (jmdns != null) {
                jmdns.unregisterAllServices();
                try {
                    jmdns.close();
                    System.out.println("🛑 mDNS Service closed successfully.");
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }));
    }
}
