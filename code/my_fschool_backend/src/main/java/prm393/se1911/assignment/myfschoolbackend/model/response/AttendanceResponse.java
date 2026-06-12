package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.sql.Timestamp;
import java.time.LocalDate;

@Builder
public record AttendanceResponse(
        String id,
        LocalDate attendanceDate,
        String status,
        Timestamp recordedAt
) {
}

