package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import prm393.se1911.assignment.myfschoolbackend.entity.Class;
import prm393.se1911.assignment.myfschoolbackend.entity.StudentClass;

import java.util.Optional;
import java.util.UUID;

public interface StudentClassRepository extends JpaRepository<StudentClass, Long> {
    @Query("SELECT sc.classField FROM StudentClass sc WHERE sc.student.id = :studentId AND sc.status = 'ACTIVE'")
    Optional<Class> findCurrentClassByStudentId(@Param("studentId") UUID studentId);
}
