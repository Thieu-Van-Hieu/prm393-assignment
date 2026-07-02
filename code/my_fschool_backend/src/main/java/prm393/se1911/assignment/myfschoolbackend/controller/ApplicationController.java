package prm393.se1911.assignment.myfschoolbackend.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import prm393.se1911.assignment.myfschoolbackend.model.request.CreateApplicationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.request.ProcessApplicationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.ApplicationResponse;
import prm393.se1911.assignment.myfschoolbackend.service.ApplicationService;
import prm393.se1911.assignment.myfschoolbackend.util.SessionUtils;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/applications")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ApplicationController {

    private final ApplicationService applicationService;

    // 🎯 1. API Phụ huynh tạo đơn từ mới
    @PostMapping
    public ResponseEntity<ApplicationResponse> createApplication(
            @Valid @RequestBody CreateApplicationRequest request,
            HttpSession session) {

        UUID parentId = SessionUtils.getUserIdFromSession(session);
        ApplicationResponse response = applicationService.createApplication(parentId, request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    // 🎯 2. API Phụ huynh xem danh sách đơn từ của con mình (đã nộp)
    @GetMapping("/parent")
    public ResponseEntity<List<ApplicationResponse>> getApplicationsByParent(HttpSession session) {

        UUID parentId = SessionUtils.getUserIdFromSession(session);
        List<ApplicationResponse> responses = applicationService.getApplicationsByParent(parentId);
        return ResponseEntity.ok(responses);
    }

    // 🎯 3. API Giáo viên xem TOÀN BỘ đơn từ cần quản lý trong hệ thống
    @GetMapping("/manage")
    public ResponseEntity<List<ApplicationResponse>> getAllApplications(HttpSession session) {

        // Đảm bảo phải đăng nhập mới lấy được danh sách quản lý
        SessionUtils.getUserIdFromSession(session);

        List<ApplicationResponse> responses = applicationService.getAllApplications();
        return ResponseEntity.ok(responses);
    }

    // 🎯 4. API Giáo viên Duyệt hoặc Từ chối một đơn từ cụ thể
    @PutMapping("/{id}/process")
    public ResponseEntity<ApplicationResponse> processApplication(
            @PathVariable("id") UUID applicationId,
            @Valid @RequestBody ProcessApplicationRequest request,
            HttpSession session) {

        UUID handlerId = SessionUtils.getUserIdFromSession(session);
        ApplicationResponse response = applicationService.processApplication(handlerId, applicationId, request);
        return ResponseEntity.ok(response);
    }
}