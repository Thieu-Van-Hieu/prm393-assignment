package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.math.BigDecimal;
import java.util.List;

@Builder
public record AcademicGradeResponse(
        String subjectName,
        String type,
        List<Integer> regularScores,
        BigDecimal midTermScore,
        BigDecimal finalTermScore,
        Double summaryScore,
        String qualitativeResult,
        String teacherComment
) {
}
