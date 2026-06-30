package prm393.se1911.assignment.myfschoolbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import prm393.se1911.assignment.myfschoolbackend.entity.Application;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ApplicationRepository extends JpaRepository<Application, UUID> {

    // 🎯 1. Tìm tất cả đơn từ của 1 Phụ huynh đã gửi (Sắp xếp theo thời gian nộp mới nhất)
    // Dùng LEFT JOIN FETCH để gom sẵn thông tin handler (User) và student vào trong 1 câu query duy nhất
    @Query("SELECT a FROM Application a " +
            "LEFT JOIN FETCH a.handler " +
            "JOIN FETCH a.student " +
            "WHERE a.parent.id = :parentId " +
            "ORDER BY a.submittedAt DESC")
    List<Application> findAllByParentIdOrderBySubmittedAtDesc(@Param("parentId") UUID parentId);

    // 🎯 2. Tìm tất cả đơn từ thuộc diện quản lý dành cho Giáo viên (Cần duyệt)
    // Giáo viên có thể xem toàn bộ đơn từ của lớp mình phụ trách hoặc toàn trường tùy logic phân quyền
    @Query("SELECT a FROM Application a " +
            "LEFT JOIN FETCH a.handler " +
            "JOIN FETCH a.student " +
            "ORDER BY a.submittedAt DESC")
    List<Application> findAllManageableApplications();

    // 🎯 3. Tìm chi tiết 1 đơn từ kèm theo toàn bộ thông tin quan hệ để tránh LazyInitializationException
    @Query("SELECT a FROM Application a " +
            "LEFT JOIN FETCH a.handler " +
            "JOIN FETCH a.student " +
            "JOIN FETCH a.parent " +
            "WHERE a.id = :id")
    Optional<Application> findByIdWithDetails(@Param("id") UUID id);
}
