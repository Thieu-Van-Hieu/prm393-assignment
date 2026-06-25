package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.LinkedHashSet;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "classes")
public class Class {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @Column(name = "class_name", nullable = false, length = 20)
    private String className;

    @Column(name = "school_year", nullable = false, length = 20)
    private String schoolYear;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JoinColumn(name = "homeroom_teacher_id")
    private User homeroomTeacher;

    @OneToMany(mappedBy = "classField")
    private Set<TimetableSlot> timetableSlots = new LinkedHashSet<>();


}