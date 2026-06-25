package prm393.se1911.assignment.myfschoolbackend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.math.BigDecimal;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "academic_grades")
public class AcademicGrade {
    @Id
    @ColumnDefault("uuid_generate_v4()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "student_id")
    private Student student;

    @Column(name = "subject_name", nullable = false, length = 50)
    private String subjectName;

    @Column(name = "semester", nullable = false, length = 20)
    private String semester;

    @Column(name = "school_year", nullable = false, length = 20)
    private String schoolYear;

    @Column(name = "frequent_grades", length = Integer.MAX_VALUE)
    private String frequentGrades;

    @Column(name = "midterm_grade", precision = 3, scale = 1)
    private BigDecimal midtermGrade;

    @Column(name = "final_grade", precision = 3, scale = 1)
    private BigDecimal finalGrade;

    @Column(name = "overall_grade", length = 10)
    private String overallGrade;

    @Column(name = "teacher_comment", length = Integer.MAX_VALUE)
    private String teacherComment;

    @Column(name = "subject_type", nullable = false, length = 20)
    private String subjectType;
   
    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JoinColumn(name = "teacher_id")
    private User teacher;
}