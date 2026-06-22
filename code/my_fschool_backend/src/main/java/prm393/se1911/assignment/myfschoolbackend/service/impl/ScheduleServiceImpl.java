package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm393.se1911.assignment.myfschoolbackend.model.response.ScheduleResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.TimetableSlotRepository;
import prm393.se1911.assignment.myfschoolbackend.service.ScheduleService;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService {

    private final TimetableSlotRepository timetableSlotRepository;

    @Override
    public List<ScheduleResponse> getStudentSchedule(UUID studentId, LocalDate date) {
        var scheduleProjections = timetableSlotRepository.getScheduleByStudentAndDateRaw(studentId, date);

        return scheduleProjections.stream().map(projection -> new ScheduleResponse(
                projection.getSlotId(),
                projection.getSubjectName(),
                projection.getTeacherName(),
                projection.getRoomName(),
                projection.getSlotNumber(),
                projection.getStartTime(),
                projection.getEndTime(),
                projection.getAttendanceStatus()
        )).collect(Collectors.toList());
    }
}
