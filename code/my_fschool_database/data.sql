-- =========================================================================
-- 1. CHÈN DỮ LIỆU BẢNG USERS (Mật khẩu để thô phục vụ test nhanh)
-- =========================================================================
-- Lưu lại các ID cố định để tái sử dụng cho các bảng quan hệ phía dưới
DO $$
DECLARE
admin_id UUID := 'a1111111-1111-1111-1111-111111111111';
    teacher1_id UUID := 't2222222-2222-2222-2222-222222222222';
    teacher2_id UUID := 't3333333-3333-3333-3333-333333333333';
    parent1_id UUID := 'p4444444-4444-4444-4444-444444444444';
    parent2_id UUID := 'p5555555-5555-5555-5555-555555555555';
    
    student1_id UUID := 's6666666-6666-6666-6666-666666666666';
    student2_id UUID := 's7777777-7777-7777-7777-777777777777';
    student3_id UUID := 's8888888-8888-8888-8888-888888888888';
    
    class1_id UUID := 'c9999999-9999-9999-9999-999999999999';
    class2_id UUID := 'c0000000-0000-0000-0000-000000000000';
    
    slot1_id UUID := 'e1111111-aaaa-bbbb-cccc-dddddddddddd';
    slot2_id UUID := 'e2222222-aaaa-bbbb-cccc-dddddddddddd';
    slot3_id UUID := 'e3333333-aaaa-bbbb-cccc-dddddddddddd';
    
    event1_id UUID := 'f1111111-bbbb-cccc-dddd-eeeeeeeeeeee';
    club1_id UUID := 'faaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
BEGIN
    -- Xóa sạch dữ liệu cũ để tránh trùng lặp nếu chạy lại nhiều lần
TRUNCATE applications, club_members, clubs, event_registrations, event_property, events, 
             academic_grades, attendance, timetable_slots, student_class, classes, parent_student, 
             students, users, user_device_tokens, school_news CASCADE;

-- Thêm Users
INSERT INTO users (id, phone_number, password, full_name, email, address, role) VALUES
                                                                                    (admin_id, '0999999999', 'admin123', 'Nguyễn Quản Trị', 'admin@fschool.edu.vn', 'FPT University', 'ADMIN'),
                                                                                    (teacher1_id, '0911111111', 'teacher123', 'Lê Thị Minh Tâm', 'tamltm@fschool.edu.vn', 'Thạch Thất, Hà Nội', 'TEACHER'),
                                                                                    (teacher2_id, '0922222222', 'teacher123', 'Trần Văn Hoàng', 'hoangtv@fschool.edu.vn', 'Cầu Giấy, Hà Nội', 'TEACHER'),
                                                                                    (parent1_id, '0933333333', 'parent123', 'Nguyễn Đình Hải', 'haind@gmail.com', 'Nam Từ Liêm, Hà Nội', 'PARENT'),
                                                                                    (parent2_id, '0944444444', 'parent123', 'Phạm Hồng Nhung', 'nhungph@gmail.com', 'Thanh Xuân, Hà Nội', 'PARENT');

-- =========================================================================
-- 2. CHÈN DỮ LIỆU HỌC SINH (STUDENTS)
-- =========================================================================
INSERT INTO students (id, student_code, full_name, date_of_birth, gender, avatar_url) VALUES
                                                                                          (student1_id, 'HE190001', 'Nguyễn Đình Khôi', '2015-05-12', 'MALE', 'https://api.multiavatar.com/Khoi.png'),
                                                                                          (student2_id, 'HE190002', 'Nguyễn Đình Khánh', '2017-09-20', 'MALE', 'https://api.multiavatar.com/Khanh.png'),
                                                                                          (student3_id, 'HE190003', 'Phạm Bảo Ngọc', '2015-11-02', 'FEMALE', 'https://api.multiavatar.com/Ngoc.png');

-- =========================================================================
-- 3. LIÊN KẾT PHỤ HUYNH - HỌC SINH (PARENT_STUDENT)
-- =========================================================================
-- Phụ huynh 1 (Hải) có 2 con: Khôi và Khánh
INSERT INTO parent_student (parent_id, student_id) VALUES
                                                       (parent1_id, student1_id),
                                                       (parent1_id, student2_id),
                                                       -- Phụ huynh 2 (Nhung) có 1 con: Bảo Ngọc
                                                       (parent2_id, student3_id);

-- =========================================================================
-- 4. BẢNG LỚP HỌC (CLASSES) & 5. XẾP LỚP (STUDENT_CLASS)
-- =========================================================================
INSERT INTO classes (id, class_name, school_year, homeroom_teacher_id) VALUES
                                                                           (class1_id, 'Lớp 4A1', '2025-2026', teacher1_id),
                                                                           (class2_id, 'Lớp 2A2', '2025-2026', teacher2_id);

-- X xếp học sinh vào lớp tương ứng
INSERT INTO student_class (student_id, class_id, status) VALUES
                                                             (student1_id, class1_id, 'ACTIVE'), -- Anh cả Khôi học lớp 4A1
                                                             (student3_id, class1_id, 'ACTIVE'), -- Bảo Ngọc cũng học lớp 4A1
                                                             (student2_id, class2_id, 'ACTIVE'); -- Em út Khánh học lớp 2A2

-- =========================================================================
-- 6. THỜI KHÓA BIỂU (TIMETABLE_SLOTS)
-- =========================================================================
-- Tạo mẫu vài tiết học cố định cho Lớp 4A1 để test lịch học trên Flutter
INSERT INTO timetable_slots (id, class_id, subject_name, teacher_name, room_name, slot_number, day_of_week, start_time, end_time) VALUES
                                                                                                                                      (slot1_id, class1_id, 'Toán Học', 'Trần Văn Hoàng', 'R.401', 1, 2, '08:00:00', '08:45:00'), -- Tiết 1 Thứ 2
                                                                                                                                      (slot2_id, class1_id, 'Ngữ Văn', 'Lê Thị Minh Tâm', 'R.401', 2, 2, '09:00:00', '09:45:00'), -- Tiết 2 Thứ 2
                                                                                                                                      (slot3_id, class1_id, 'Tiếng Anh', 'Ms. Emily', 'R.Language', 1, 3, '08:00:00', '08:45:00'); -- Tiết 1 Thứ 3

-- =========================================================================
-- 7. NHẬT KÝ ĐIỂM DANH ĐỘNG (ATTENDANCE) - Tính theo ngày thực tế lúc chạy
-- =========================================================================
INSERT INTO attendance (student_id, slot_id, attendance_date, status) VALUES
                                                                          -- Điểm danh cho học sinh Khôi (Thứ 2 đã đi học, Thứ 3 đang chờ)
                                                                          (student1_id, slot1_id, CURRENT_DATE - (EXTRACT(DOW FROM CURRENT_DATE)::INTEGER - 2) * INTERVAL '1 day', 'ATTENDED'),
                                                                          (student1_id, slot2_id, CURRENT_DATE - (EXTRACT(DOW FROM CURRENT_DATE)::INTEGER - 2) * INTERVAL '1 day', 'ATTENDED'),
                                                                          -- Điểm danh cho học sinh Bảo Ngọc (Nghỉ học có phép ngày Thứ 2)
                                                                          (student3_id, slot1_id, CURRENT_DATE - (EXTRACT(DOW FROM CURRENT_DATE)::INTEGER - 2) * INTERVAL '1 day', 'ABSENT');

-- =========================================================================
-- 8. ĐIỂM SỐ & NHẬN XÉT (ACADEMIC_GRADES)
-- =========================================================================
INSERT INTO academic_grades (student_id, subject_name, semester, school_year, frequent_grades, midterm_grade, final_grade, overall_grade, teacher_comment) VALUES
                                                                                                                                                               (student1_id, 'Toán Học', 'Học kỳ II', '2025-2026', '9.0,8.5,10.0', 9.0, 9.5, 'A+', 'Khôi học toán rất tốt, tư duy logic nhanh nhẹn.'),
                                                                                                                                                               (student1_id, 'Ngữ Văn', 'Học kỳ II', '2025-2026', '7.0,8.0', 7.5, 8.0, 'B', 'Cần chú ý rèn chữ viết sạch đẹp hơn.'),
                                                                                                                                                               (student3_id, 'Toán Học', 'Học kỳ II', '2025-2026', '8.0,8.0,7.5', 8.0, 8.5, 'A', 'Ngoan ngoãn, tập trung nghe giảng.');

-- =========================================================================
-- 9. SỰ KIỆN (EVENTS) & 10. THUỘC TÍNH & 11. ĐĂNG KÝ
-- =========================================================================
INSERT INTO events (id, badge, title, base64_image, description) VALUES
    (event1_id, 'Hội Thao', 'Ngày Hội Thể Thao FSchool 2026', 'base64_string_placeholder_here', 'Ngày hội nhằm nâng cao sức khỏe thể chất và tinh thần đồng đội cho học sinh toàn trường.');

INSERT INTO event_property (event_id, property_name, property_value) VALUES
                                                                         (event1_id, 'Địa điểm', 'Sân vận động FPT Campus'),
                                                                         (event1_id, 'Trang phục', 'Áo đồng thể thao lớp'),
                                                                         (event1_id, 'Thời gian', '07:30 sáng Thứ Bảy tuần này');

-- Phụ huynh Hải đăng ký tham gia với con
INSERT INTO event_registrations (event_id, parent_id, number_of_attendees, notes) VALUES
    (event1_id, parent1_id, 3, 'Gia đình gồm bố và 2 cháu tham gia chạy tiếp sức.');

-- =========================================================================
-- 12. CÂU LẠC BỘ (CLUBS) & 13. THÀNH VIÊN (CLUB_MEMBERS)
-- =========================================================================
INSERT INTO clubs (id, club_name, description, base64_image, schedules) VALUES
    (club1_id, 'CLB Bóng Đá Nhí', 'Rèn luyện kỹ thuật sân cỏ cơ bản và tư duy chiến thuật thi đấu.', 'soccer_image_base64', 'Chiều Thứ 4 (16:30 - 18:00) và Sáng Chủ Nhật (08:00 - 09:30)');

-- Cu Khôi tham gia CLB Bóng đá
INSERT INTO club_members (club_id, student_id, role) VALUES
    (club1_id, student1_id, 'MEMBER');

-- =========================================================================
-- 14. ĐƠN TỪ NGHỈ HỌC (APPLICATIONS) - Động theo ngày hiện tại
-- =========================================================================
INSERT INTO applications (student_id, parent_id, application_type, reason, from_date, to_date, status, submitted_at) VALUES
    -- Đơn nghỉ học của Bảo Ngọc do Phụ huynh Nhung gửi ngày hôm nay
    (student3_id, parent2_id, 'SICK_LEAVE', 'Cháu bị sốt phát ban, gia đình xin phép cho cháu nghỉ học điều trị tại nhà.', CURRENT_DATE, CURRENT_DATE + INTERVAL '2 day', 'APPROVED', NOW());

-- =========================================================================
-- 16. TIN TỨC TRANG CHỦ (SCHOOL_NEWS)
-- =========================================================================
INSERT INTO school_news (title, summary, content, thumbnail_url, created_at) VALUES
                                                                                 ('Thông báo Nghỉ lễ định kỳ', 'Lịch nghỉ lễ sắp tới dành cho học sinh toàn hệ thống.', 'Nhà trường xin thông báo lịch nghỉ lễ chính thức kéo dài 3 ngày kể từ đầu tuần sau...', 'https://fschool.edu.vn/news/thumbnail1.jpg', NOW()),
                                                                                 ('Khen ngợi học sinh đạt giải Toán Quốc Tế', 'Tuyên dương em Nguyễn Đình Khôi lớp 4A1.', 'Chúc mừng em đã xuất sắc vượt qua vòng chung kết kỳ thi toán quốc tế SASMO...', 'https://fschool.edu.vn/news/thumbnail2.jpg', NOW() - INTERVAL '1 day');

END $$;