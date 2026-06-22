package prm393.se1911.assignment.myfschoolbackend.model.projection;

import java.time.LocalTime;
import java.util.UUID;

public interface ScheduleProjection {
    UUID getSlotId();

    String getSubjectName();

    String getTeacherName();

    String getRoomName();

    Integer getSlotNumber();

    LocalTime getStartTime();

    LocalTime getEndTime();

    String getAttendanceStatus();
}
