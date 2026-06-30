package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import prm393.se1911.assignment.myfschoolbackend.entity.Student;

import java.util.UUID;

public interface StudentRepository extends JpaRepository<Student, UUID> {
}
