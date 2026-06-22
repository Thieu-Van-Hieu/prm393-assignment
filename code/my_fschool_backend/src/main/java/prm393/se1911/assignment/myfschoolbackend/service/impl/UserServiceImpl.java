package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import prm393.se1911.assignment.myfschoolbackend.entity.Student;
import prm393.se1911.assignment.myfschoolbackend.entity.User;
import prm393.se1911.assignment.myfschoolbackend.entity.UserClass;
import prm393.se1911.assignment.myfschoolbackend.model.response.*;
import prm393.se1911.assignment.myfschoolbackend.repository.AttendanceRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.UserClassRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.UserRepository;
import prm393.se1911.assignment.myfschoolbackend.service.UserService;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final AttendanceRepository attendanceRepository;
    private final UserClassRepository userClassRepository;

    @Transactional(readOnly = true)
    public UserResponse getUserContext(UUID userId) {
        // 1. Lấy thông tin tài khoản cốt lõi
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // 2. Lấy danh sách không gian lớp học đang hoạt động của User
        List<UserClass> workspaces = userClassRepository.findAllByUserIdAndStatus(userId, "ACTIVE");
        LocalDate today = LocalDate.now();

        // 3. Map danh sách không gian lớp học sang danh sách DTO thông qua hàm nhỏ chuyên trách
        List<UserWorkspaceResponse> userWorkspaceResponses = workspaces.stream()
                .map(uc -> buildWorkspaceResponse(uc, today))
                .toList();

        // 4. Trả về cấu trúc dữ liệu tổng hợp sạch sẽ
        return UserResponse.builder()
                .id(user.getId().toString())
                .fullName(user.getFullName())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .address(user.getAddress())
                .userWorkspaceResponses(userWorkspaceResponses)
                .build();
    }

    /**
     * Hàm nhỏ 1: Chuyên trách chuyển đổi một thực thể UserClass thành một Workspace DTO hoàn chỉnh
     */
    private UserWorkspaceResponse buildWorkspaceResponse(UserClass uc, LocalDate date) {
        final var classField = uc.getClassField();
        Student student = uc.getStudentProfile();

        // Tách logic xây dựng Student Profile ra một hàm riêng
        StudentProfileResponse studentProfileResponse = buildStudentProfileResponse(student, classField, date);

        return UserWorkspaceResponse.builder()
                .classId(classField.getId().toString())
                .className(classField.getClassName())
                .schoolYear(classField.getSchoolYear())
                .roleName(uc.getRole())
                .profile(studentProfileResponse)
                .build();
    }

    /**
     * Hàm nhỏ 2: Chuyên trách bốc thông tin điểm danh và đóng gói hồ sơ học vụ chi tiết cho Học sinh
     */
    private StudentProfileResponse buildStudentProfileResponse(Student student, prm393.se1911.assignment.myfschoolbackend.entity.Class classField, LocalDate date) {
        if (student == null) {
            return null;
        }

        // Tách logic truy vấn và map điểm danh ra hàm riêng
        AttendanceResponse attendanceResponse = getTodayAttendanceResponse(student.getId(), date);

        return StudentProfileResponse.builder()
                .id(student.getId().toString())
                .studentCode(student.getStudentCode())
                .fullName(student.getFullName())
                .dateOfBirth(student.getDateOfBirth())
                .gender(student.getGender())
                .avatarUrl(student.getAvatarUrl())
                .todayAttendance(attendanceResponse)
                .currentClass(ClassResponse.builder()
                        .id(classField.getId().toString())
                        .className(classField.getClassName())
                        .schoolYear(classField.getSchoolYear())
                        .build())
                .build();
    }

    /**
     * Hàm nhỏ 3: Chuyên trách tương tác với AttendanceRepository để lấy trạng thái điểm danh hôm nay
     */
    private AttendanceResponse getTodayAttendanceResponse(UUID studentId, LocalDate date) {
        return attendanceRepository.findFirstByStudentIdAndAttendanceDate(studentId, date)
                .map(a -> AttendanceResponse.builder()
                        .id(a.getId().toString())
                        .attendanceDate(a.getAttendanceDate())
                        .status(a.getStatus())
                        .recordedAt(a.getRecordedAt())
                        .build())
                .orElse(null);
    }
}