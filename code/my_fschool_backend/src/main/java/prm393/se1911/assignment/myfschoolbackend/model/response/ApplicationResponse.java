package prm393.se1911.assignment.myfschoolbackend.model.response;

import java.util.UUID;

public record ApplicationResponse(
        UUID id,
        String title,            // Bản chất là applicationType chuyển sang tiếng Việt hoặc giữ nguyên tùy phen
        String status,           // 'PENDING', 'APPROVED', 'REJECTED'
        String sentDate,         // submittedAt định dạng 'dd/MM/yyyy HH:mm'
        String processedDate,    // processedAt định dạng 'dd/MM/yyyy HH:mm' (nếu có)
        String handlerName,      // Họ tên Giáo viên xử lý lấy từ bảng User qua handler_id
        String fromDate,         // Định dạng 'dd/MM/yyyy' (nếu có)
        String toDate,           // Định dạng 'dd/MM/yyyy' (nếu có)
        String requestContent,   // Lý do (reason) gửi đơn
        String responseContent   // Phản hồi từ nhà trường (schoolResponse)
) {
}
