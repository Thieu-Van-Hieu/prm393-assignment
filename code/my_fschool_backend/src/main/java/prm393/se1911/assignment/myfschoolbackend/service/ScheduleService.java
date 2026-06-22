package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.response.ScheduleResponse;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface ScheduleService {
    List<ScheduleResponse> getStudentSchedule(UUID studentId, LocalDate date);
}
