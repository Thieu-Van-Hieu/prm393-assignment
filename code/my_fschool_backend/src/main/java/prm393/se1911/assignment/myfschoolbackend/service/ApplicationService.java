package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.request.CreateApplicationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ProcessApplicationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.ApplicationResponse;

import java.util.List;
import java.util.UUID;

public interface ApplicationService {
    // Phụ huynh tạo đơn từ
    ApplicationResponse createApplication(UUID parentId, CreateApplicationRequest request);

    // Phụ huynh xem danh sách đơn mình đã gửi
    List<ApplicationResponse> getApplicationsByParent(UUID parentId);

    // Giáo viên/Nhân viên trường duyệt hoặc từ chối đơn từ
    ApplicationResponse processApplication(UUID handlerId, UUID applicationId, ProcessApplicationRequest request);

    // Xem toàn bộ đơn từ (Dành cho màn hình quản lý của Giáo viên)
    List<ApplicationResponse> getAllApplications();
}
