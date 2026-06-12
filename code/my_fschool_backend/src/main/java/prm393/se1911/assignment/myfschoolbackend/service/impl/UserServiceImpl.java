package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import prm393.se1911.assignment.myfschoolbackend.entity.Student;
import prm393.se1911.assignment.myfschoolbackend.entity.User;
import prm393.se1911.assignment.myfschoolbackend.model.response.AttendanceResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.ClassResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.StudentProfileResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.UserResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.AttendanceRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.StudentClassRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.StudentRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.UserRepository;
import prm393.se1911.assignment.myfschoolbackend.service.UserService;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final AttendanceRepository attendanceRepository;
    private final StudentClassRepository studentClassRepository;

    @Transactional(readOnly = true)
    public UserResponse getUserContext(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserResponse.UserResponseBuilder responseBuilder = UserResponse.builder()
                .id(user.getId().toString())
                .fullName(user.getFullName())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .address(user.getAddress())
                .roleName(user.getRole()); // 'PARENT' hoặc 'STUDENT'

        if ("STUDENT".equalsIgnoreCase(user.getRole())) {
            // Nhánh 1: Nếu là Học sinh, lấy đúng 1 Profile liên kết
            studentRepository.findByUserId(user.getId())
                    .ifPresent(student -> responseBuilder.studentProfile(buildStudentProfileDto(student)));
            responseBuilder.parentStudents(new ArrayList<>()); // Trả về mảng rỗng

        } else if ("PARENT".equalsIgnoreCase(user.getRole())) {
            // Nhánh 2: Nếu là Phụ huynh, lấy danh sách toàn bộ các con
            List<Student> children = studentRepository.findAllByParentId(user.getId());
            List<StudentProfileResponse> childrenDtos = children.stream()
                    .map(this::buildStudentProfileDto)
                    .toList();

            responseBuilder.studentProfile(null);
            responseBuilder.parentStudents(childrenDtos);
        }

        return responseBuilder.build();
    }

    // Helper method kết hợp thông tin học vụ của một Học sinh cụ thể
    private StudentProfileResponse buildStudentProfileDto(Student student) {
        UUID studentId = student.getId();
        LocalDate today = LocalDate.now();

        // 1. Lấy thông tin lớp hiện tại
        ClassResponse classResponse = studentClassRepository.findCurrentClassByStudentId(studentId)
                .map(c -> ClassResponse.builder()
                        .id(c.getId().toString())
                        .className(c.getClassName())
                        .schoolYear(c.getSchoolYear())
                        .build())
                .orElse(null);

        // 2. Lấy trạng thái điểm danh hôm nay
        AttendanceResponse attendanceResponse = attendanceRepository.findFirstByStudentIdAndAttendanceDate(studentId, today)
                .map(a -> AttendanceResponse.builder()
                        .id(a.getId().toString())
                        .attendanceDate(a.getAttendanceDate())
                        .status(a.getStatus())
                        .recordedAt(a.getRecordedAt())
                        .build())
                .orElse(null);

        return StudentProfileResponse.builder()
                .id(studentId.toString())
                .studentCode(student.getStudentCode())
                .fullName(student.getFullName())
                .dateOfBirth(student.getDateOfBirth())
                .gender(student.getGender())
                .avatarUrl(student.getAvatarUrl())
                .currentClass(classResponse)
                .todayAttendance(attendanceResponse)
                .build();
    }
}