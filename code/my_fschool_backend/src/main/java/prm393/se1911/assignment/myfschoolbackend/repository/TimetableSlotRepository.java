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
                ts.teacher_id AS teacherId,
                u.full_name AS teacherName, -- 🎯 THÊM: Lấy tên thật của giáo viên từ bảng users
                ts.room_name AS roomName,
                ts.slot_number AS slotNumber,
                ts.start_time AS startTime,
                ts.end_time AS endTime,
                COALESCE(a.status, 'PENDING') AS attendanceStatus
            FROM timetable_slots ts
            -- 🎯 THAY ĐỔI: Chuyển từ student_class sang user_class và map qua student_profile_id
            JOIN user_class uc ON ts.class_id = uc.class_id
            -- 🎯 THÊM: JOIN sang bảng users để lấy thông tin hiển thị của Giáo viên dạy tiết đó
            LEFT JOIN users u ON ts.teacher_id = u.id
            LEFT JOIN attendance a ON ts.id = a.slot_id
                AND a.student_id = :studentId
                AND a.attendance_date = :date
            WHERE uc.student_profile_id = :studentId
              AND uc.status = 'ACTIVE'
              -- 🎯 KHÓA BẢO MẬT: Đảm bảo bản ghi trong user_class là tư cách STUDENT học vụ
              AND uc.role_id = '00000000-0000-0000-0000-000000000001'::uuid
              AND ts.day_of_week = EXTRACT(ISODOW FROM CAST(:date AS DATE))
            ORDER BY ts.slot_number
            """, nativeQuery = true)
    List<ScheduleProjection> getScheduleByStudentAndDateRaw(
            @Param("studentId") UUID studentId,
            @Param("date") LocalDate date
    );
}
