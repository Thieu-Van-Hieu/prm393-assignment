package prm393.se1911.assignment.myfschoolbackend.model.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.util.UUID;

public record CreateApplicationRequest(
        @NotNull(message = "ID học sinh không được để trống")
        UUID studentId,

        @NotBlank(message = "Loại đơn từ không được để trống")
        String applicationType, // 'SICK_LEAVE', 'ACTIVITY_EXEMPTION',...

        @NotBlank(message = "Lý do không được để trống")
        String reason,

        LocalDate fromDate, // Chấp nhận NULL từ FE nếu là đơn không theo ngày cố định
        LocalDate toDate    // Chấp nhận NULL từ FE
) {
}
