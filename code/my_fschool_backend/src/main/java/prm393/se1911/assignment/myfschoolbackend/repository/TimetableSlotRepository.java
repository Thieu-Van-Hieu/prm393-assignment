package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import prm393.se1911.assignment.myfschoolbackend.entity.TimetableSlot;
import prm393.se1911.assignment.myfschoolbackend.model.projection.ScheduleProjection;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface TimetableSlotRepository extends JpaRepository<TimetableSlot, UUID> {
    @Query(value = """
            SELECT
                ts.id AS slotId,
                ts.subject_name AS subjectName,
                ts.teacher_name AS teacherName,
                ts.room_name AS roomName,
                ts.slot_number AS slotNumber,
                ts.start_time AS startTime,
                ts.end_time AS endTime,
                COALESCE(a.status, 'PENDING') AS attendanceStatus
            FROM timetable_slots ts
            JOIN student_class sc ON ts.class_id = sc.class_id
            LEFT JOIN attendance a ON ts.id = a.slot_id
                AND a.student_id = :studentId
                AND a.attendance_date = :date
            WHERE sc.student_id = :studentId
              AND sc.status = 'ACTIVE'
              AND ts.day_of_week = EXTRACT(ISODOW FROM CAST(:date AS DATE))
            ORDER BY ts.slot_number
            """, nativeQuery = true)
    List<ScheduleProjection> getScheduleByStudentAndDateRaw(
            @Param("studentId") UUID studentId,
            @Param("date") LocalDate date
    );
}
