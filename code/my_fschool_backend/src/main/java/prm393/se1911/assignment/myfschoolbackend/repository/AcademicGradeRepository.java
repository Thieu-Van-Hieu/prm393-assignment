package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import prm393.se1911.assignment.myfschoolbackend.entity.AcademicGrade;

import java.util.List;
import java.util.UUID;

public interface AcademicGradeRepository extends JpaRepository<AcademicGrade, UUID> {
    List<AcademicGrade> findByStudentId(UUID studentId);
}
