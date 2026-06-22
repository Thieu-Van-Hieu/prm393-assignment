package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.time.LocalTime;
import java.util.UUID;

@Builder
public record ScheduleResponse(
        UUID slotId,
        String subjectName,
        String teacherName,
        String roomName,
        int slotNumber,
        LocalTime startTime,
        LocalTime endTime,
        String attendanceStatus
) {
}
