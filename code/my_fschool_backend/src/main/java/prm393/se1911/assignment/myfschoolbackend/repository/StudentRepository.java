package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import prm393.se1911.assignment.myfschoolbackend.entity.Student;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface StudentRepository extends JpaRepository<Student, UUID> {

    Optional<Student> findByUserId(UUID userId);

    @Query("SELECT s FROM Student s JOIN s.parents p WHERE p.id = :parentId")
    List<Student> findAllByParentId(@Param("parentId") UUID parentId);
}