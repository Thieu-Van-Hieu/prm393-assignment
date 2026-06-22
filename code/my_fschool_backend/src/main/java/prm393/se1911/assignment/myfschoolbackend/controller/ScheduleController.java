package prm393.se1911.assignment.myfschoolbackend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import prm393.se1911.assignment.myfschoolbackend.model.response.ScheduleResponse;
import prm393.se1911.assignment.myfschoolbackend.service.ScheduleService;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/schedules")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;

    @GetMapping
    public ResponseEntity<List<ScheduleResponse>> getTimetable(
            @RequestParam("studentId") UUID studentId,
            @RequestParam(value = "date", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date
    ) {
        LocalDate targetDate = (date != null) ? date : LocalDate.now();

        List<ScheduleResponse> schedule = scheduleService.getStudentSchedule(studentId, targetDate);
        return ResponseEntity.ok(schedule);
    }
}