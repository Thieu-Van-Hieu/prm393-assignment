package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "user_class")
public class UserClass implements Serializable {
    @Serial
    private static final long serialVersionUID = -9050797585227729640L;
    @EmbeddedId
    private UserClassId id;

    @MapsId("userId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @MapsId("classId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "class_id", nullable = false)
    private Class classField;

    @MapsId("studentProfileId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "student_profile_id", nullable = false)
    private Student studentProfile;

    @Column(name = "role", nullable = false, length = 20)
    private String role;

    @ColumnDefault("'ACTIVE'")
    @Column(name = "status", length = 20)
    private String status;


}