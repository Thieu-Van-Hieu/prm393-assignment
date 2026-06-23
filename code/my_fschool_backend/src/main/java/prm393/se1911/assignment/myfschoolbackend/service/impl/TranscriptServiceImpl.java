package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import prm393.se1911.assignment.myfschoolbackend.entity.AcademicGrade;
import prm393.se1911.assignment.myfschoolbackend.model.response.AcademicGradeResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.SemesterTranscriptResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.AcademicGradeRepository;
import prm393.se1911.assignment.myfschoolbackend.service.TranscriptService;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class TranscriptServiceImpl implements TranscriptService {
    private final AcademicGradeRepository academicGradeRepository;

    @Override
    public List<SemesterTranscriptResponse> getSemesterTranscripts(UUID studentId) {
        List<AcademicGrade> grades = academicGradeRepository.findByStudentId(studentId);

        // 1. Nhóm toàn bộ bản ghi theo chuỗi định dạng mong muốn: "Semester (SchoolYear)"
        Map<String, List<AcademicGradeResponse>> groupedBySemester = grades.stream()
                .collect(Collectors.groupingBy(
                        grade -> String.format("%s (%s)", grade.getSemester(), grade.getSchoolYear()),
                        Collectors.mapping(this::convertToResponse, Collectors.toList())
                ));

        // 2. Chuyển đổi Map thành List<SemesterTranscriptResponse> khớp chuẩn DTO cấu trúc mảng phẳng
        return groupedBySemester.entrySet().stream()
                .map(entry -> new SemesterTranscriptResponse(entry.getKey(), entry.getValue()))
                .collect(Collectors.toList());
    }

    private AcademicGradeResponse convertToResponse(AcademicGrade grade) {
        // 1. Khởi tạo các giá trị bóc tách
        List<Integer> regularScores = Collections.emptyList();
        Double summaryScore = null;
        String qualitativeResult = null;

        // 2. Parse chuỗi số nguyên sạch từ DB (Ví dụ: "9,8,10" -> [9, 8, 10])
        if (grade.getFrequentGrades() != null && !grade.getFrequentGrades().isBlank()) {
            try {
                regularScores = Arrays.stream(grade.getFrequentGrades().split(","))
                        .map(String::trim)
                        .map(Integer::parseInt) // Khớp chuẩn List<Integer>
                        .collect(Collectors.toList());
            } catch (NumberFormatException ignored) {
            }
        }

        // 3. Phân loại logic dựa 100% vào cột `subject_type`
        if (grade.getSubjectType() != null && "QUALITATIVE".equalsIgnoreCase(grade.getSubjectType())) {
            qualitativeResult = grade.getOverallGrade(); // Nhận diện: "Đạt" hoặc "Chưa đạt"
        } else {
            // Nếu là môn NUMERIC thì parse trường overall_grade thành số thực Double
            if (grade.getOverallGrade() != null) {
                try {
                    summaryScore = Double.parseDouble(grade.getOverallGrade());
                } catch (NumberFormatException e) {
                    summaryScore = 0.0; // Fallback an toàn nếu dữ liệu DB lỗi chuỗi
                }
            }
        }

        // 4. Build DTO trả ra khớp hoàn toàn với Flutter MappableClass
        return AcademicGradeResponse.builder()
                .subjectName(grade.getSubjectName())
                .type(grade.getSubjectType() != null ? grade.getSubjectType().toUpperCase() : "NUMERIC")
                .regularScores(regularScores)
                .midTermScore(grade.getMidtermGrade())
                .finalTermScore(grade.getFinalGrade())
                .summaryScore(summaryScore)
                .qualitativeResult(qualitativeResult)
                .teacherComment(grade.getTeacherComment())
                .build();
    }
}