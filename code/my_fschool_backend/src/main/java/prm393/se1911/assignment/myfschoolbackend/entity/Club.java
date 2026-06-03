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
@Table(name = "clubs")
public class Club {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @Column(name = "club_name", nullable = false, length = 100)
    private String clubName;

    @Column(name = "description", length = Integer.MAX_VALUE)
    private String description;

    @Column(name = "base64_image", length = Integer.MAX_VALUE)
    private String base64Image;

    @Column(name = "schedules", length = Integer.MAX_VALUE)
    private String schedules;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Timestamp createdAt;

    @OneToMany(mappedBy = "club")
    private Set<prm393.se1911.assignment.myfschoolbackend.entity.ClubMember> clubMembers = new LinkedHashSet<>();


}