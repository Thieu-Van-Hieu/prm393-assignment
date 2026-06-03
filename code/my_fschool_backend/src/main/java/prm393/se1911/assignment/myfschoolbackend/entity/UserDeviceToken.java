package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.sql.Timestamp;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "user_device_tokens")
public class UserDeviceToken {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "device_token", nullable = false, length = Integer.MAX_VALUE)
    private String deviceToken;

    @Column(name = "device_type", nullable = false, length = 10)
    private String deviceType;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "last_active")
    private Timestamp lastActive;


}