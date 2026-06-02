package mss301.se1911.group.assignment.myfschoolbackend.repository;

import mss301.se1911.group.assignment.myfschoolbackend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByPhoneNumber(String phoneNumber);
}
