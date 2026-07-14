package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import prm393.se1911.assignment.myfschoolbackend.entity.EventRegistration;

import java.util.UUID;

public interface EventRegistrationRepository extends JpaRepository<EventRegistration, UUID> {
    EventRegistration findByParentIdAndEventId(UUID parentId, UUID eventId);

    boolean existsByParentIdAndEventId(UUID parentId, UUID eventId);
}
