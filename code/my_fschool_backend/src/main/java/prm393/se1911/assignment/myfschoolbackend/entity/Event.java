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
@Table(name = "events")
public class Event {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @Column(name = "badge", nullable = false, length = 20)
    private String badge;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "base64_image", length = Integer.MAX_VALUE)
    private String base64Image;

    @Column(name = "description", length = Integer.MAX_VALUE)
    private String description;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Timestamp createdAt;

    @OneToMany(mappedBy = "event")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.EventProperty> eventProperties = new LinkedHashSet<>();

    @OneToMany(mappedBy = "event")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.EventRegistration> eventRegistrations = new LinkedHashSet<>();


}