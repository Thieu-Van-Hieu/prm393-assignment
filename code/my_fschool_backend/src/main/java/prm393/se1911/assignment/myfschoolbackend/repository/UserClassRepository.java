package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import prm393.se1911.assignment.myfschoolbackend.entity.UserClass;
import prm393.se1911.assignment.myfschoolbackend.entity.UserClassId;

import java.util.List;
import java.util.UUID;

public interface UserClassRepository extends JpaRepository<UserClass, UserClassId> {
    List<UserClass> findAllByUserIdAndStatus(UUID userId, String status);
}
