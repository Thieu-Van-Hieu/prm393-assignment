package prm393.se1911.assignment.myfschoolbackend.model.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record ProcessApplicationRequest(
        @NotBlank(message = "Trạng thái xử lý không được để trống")
        @Pattern(regexp = "^(APPROVED|REJECTED)$", message = "Trạng thái phải là APPROVED hoặc REJECTED")
        String status,

        String schoolResponse // Lời nhắn phản hồi từ thầy cô
) {
}
