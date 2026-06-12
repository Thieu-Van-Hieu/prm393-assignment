package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.time.LocalDate;

@Builder
public record StudentProfileResponse(
        String id,
        String studentCode,
        String fullName,
        LocalDate dateOfBirth,
        String gender,
        String avatarUrl,
        ClassResponse currentClass,
        AttendanceResponse todayAttendance
) {
}
