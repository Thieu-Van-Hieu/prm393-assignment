package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.sql.Time;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "timetable_slots")
public class TimetableSlot {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "class_id")
    private Class classField;

    @Column(name = "subject_name", nullable = false, length = 50)
    private String subjectName;

    @Column(name = "teacher_name", length = 100)
    private String teacherName;

    @Column(name = "room_name", length = 20)
    private String roomName;

    @Column(name = "slot_number", nullable = false)
    private Integer slotNumber;

    @Column(name = "day_of_week", nullable = false)
    private Integer dayOfWeek;

    @Column(name = "start_time", nullable = false)
    private Time startTime;

    @Column(name = "end_time", nullable = false)
    private Time endTime;

    @OneToMany(mappedBy = "slot")
    private Set<Attendance> attendances = new LinkedHashSet<>();


}