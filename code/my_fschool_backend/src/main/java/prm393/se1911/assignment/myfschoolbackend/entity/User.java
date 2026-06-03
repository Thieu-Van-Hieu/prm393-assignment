package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.sql.Timestamp;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "users")
public class User {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @Column(name = "phone_number", nullable = false, length = 15)
    private String phoneNumber;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "address", length = Integer.MAX_VALUE)
    private String address;

    @Column(name = "role", nullable = false, length = 20)
    private String role;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Timestamp createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at")
    private Timestamp updatedAt;

    @OneToMany(mappedBy = "parent")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.Application> applications = new LinkedHashSet<>();

    @OneToMany(mappedBy = "homeroomTeacher")
    private Set<Class> classes = new LinkedHashSet<>();

    @OneToMany(mappedBy = "parent")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.EventRegistration> eventRegistrations = new LinkedHashSet<>();

    @ManyToMany(mappedBy = "parents")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.Student> students = new LinkedHashSet<>();

    @OneToMany(mappedBy = "user")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.UserDeviceToken> userDeviceTokens = new LinkedHashSet<>();


}