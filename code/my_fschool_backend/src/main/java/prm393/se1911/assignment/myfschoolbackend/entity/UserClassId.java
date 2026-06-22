package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.io.Serial;
import java.io.Serializable;
import java.util.UUID;

@Getter
@Setter
@EqualsAndHashCode
@Embeddable
public class UserClassId implements Serializable {
    @Serial
    private static final long serialVersionUID = -7147674997973441223L;
    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "class_id", nullable = false)
    private UUID classId;

    @Column(name = "student_profile_id", nullable = false)
    private UUID studentProfileId;


}