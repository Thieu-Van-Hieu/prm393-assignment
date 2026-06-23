package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.util.List;

@Builder
public record SemesterTranscriptResponse(
        String semesterName,
        List<AcademicGradeResponse> academicGrades
) {
}
