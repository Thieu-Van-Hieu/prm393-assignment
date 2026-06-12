package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import prm393.se1911.assignment.myfschoolbackend.entity.Attendance;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    Optional<Attendance> findFirstByStudentIdAndAttendanceDate(UUID studentId, LocalDate date);
}
