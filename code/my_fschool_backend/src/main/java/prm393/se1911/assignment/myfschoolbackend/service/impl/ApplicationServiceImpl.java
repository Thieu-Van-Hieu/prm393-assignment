package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import prm393.se1911.assignment.myfschoolbackend.entity.Application;
import prm393.se1911.assignment.myfschoolbackend.entity.Student;
import prm393.se1911.assignment.myfschoolbackend.entity.User;
import prm393.se1911.assignment.myfschoolbackend.model.request.CreateApplicationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ProcessApplicationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.ApplicationResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.ApplicationRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.StudentRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.UserRepository;
import prm393.se1911.assignment.myfschoolbackend.service.ApplicationService;
import prm393.se1911.assignment.myfschoolbackend.util.TimestampUtils;

import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ApplicationServiceImpl implements ApplicationService {

    private final ApplicationRepository applicationRepository;
    private final StudentRepository studentRepository;
    private final UserRepository userRepository;

    // Định dạng thời gian chuẩn để hiển thị mượt mà trên Flutter
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").withZone(ZoneId.systemDefault());

    @Override
    @Transactional
    public ApplicationResponse createApplication(UUID parentId, CreateApplicationRequest request) {
        User parent = userRepository.findById(parentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản phụ huynh"));

        Student student = studentRepository.findById(request.studentId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin học sinh"));

        Application application = Application.builder()
                .parent(parent)
                .student(student)
                .applicationType(request.applicationType())
                .reason(request.reason())
                .fromDate(request.fromDate())
                .toDate(request.toDate())
                .status("PENDING")
                .build();

        Application savedApp = applicationRepository.save(application);
        return mapToResponse(savedApp);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ApplicationResponse> getApplicationsByParent(UUID parentId) {
        return applicationRepository.findAllByParentIdOrderBySubmittedAtDesc(parentId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    @Transactional
    public ApplicationResponse processApplication(UUID handlerId, UUID applicationId, ProcessApplicationRequest request) {
        Application application = applicationRepository.findByIdWithDetails(applicationId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn từ yêu cầu"));

        User handler = userRepository.findById(handlerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản người duyệt"));

        application.setStatus(request.status());
        application.setSchoolResponse(request.schoolResponse());
        application.setHandler(handler);
        application.setProcessedAt(TimestampUtils.getCurrentTimestamp());

        Application updatedApp = applicationRepository.save(application);
        return mapToResponse(updatedApp);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ApplicationResponse> getAllApplications() {
        return applicationRepository.findAllManageableApplications()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    // 🎯 Hàm Mapper thủ công chuyển đổi từ Entity sang Record DTO an toàn
    private ApplicationResponse mapToResponse(Application app) {
        String titleVi = switch (app.getApplicationType()) {
            case "SICK_LEAVE" -> "Đơn xin nghỉ học";
            case "ACTIVITY_EXEMPTION" -> "Đơn xin miễn giảm hoạt động";
            default -> "Đơn từ khác";
        };

        return new ApplicationResponse(
                app.getId(),
                titleVi,
                app.getStatus(),
                app.getSubmittedAt() != null ? dateTimeFormatter.format(app.getSubmittedAt().toLocalDateTime()) : null,
                app.getProcessedAt() != null ? dateTimeFormatter.format(app.getProcessedAt().toLocalDateTime()) : null,
                app.getHandler() != null ? app.getHandler().getFullName() : null, // Trả về Họ tên thay vì ID để FE hiển thị luôn
                app.getFromDate() != null ? dateFormatter.format(app.getFromDate()) : null,
                app.getToDate() != null ? dateFormatter.format(app.getToDate()) : null,
                app.getReason(),
                app.getSchoolResponse()
        );
    }
}