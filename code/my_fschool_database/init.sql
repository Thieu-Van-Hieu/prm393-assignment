-- =========================================================================
-- MỤC KHỞI ĐẦU: XÓA SẠCH CẤU TRÚC VÀ DỮ LIỆU CŨ (RESET DATABASE)
-- =========================================================================
DROP TABLE IF EXISTS school_news CASCADE;
DROP TABLE IF EXISTS user_device_tokens CASCADE;
DROP TABLE IF EXISTS applications CASCADE;
DROP TABLE IF EXISTS club_members CASCADE;
DROP TABLE IF EXISTS clubs CASCADE;
DROP TABLE IF EXISTS event_registrations CASCADE;
DROP TABLE IF EXISTS event_property CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS academic_grades CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS timetable_slots CASCADE;
DROP TABLE IF EXISTS student_class CASCADE;
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS parent_student CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- KÍCH HOẠT EXTENSION ĐỂ SINH SỐ UUID TỰ ĐỘNG
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- MỤC A: CẤU TRÚC BẢNG CORE LOGIC (TRIỂN KHAI TRƯỚC)
-- =========================================================================

-- 1. Bảng Người dùng hệ thống (Quản lý thông tin Đăng nhập tập trung bằng SĐT)
CREATE TABLE users (
                       id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                       phone_number VARCHAR(15) UNIQUE NOT NULL, -- Cả Parent và Student đều dùng SĐT để đăng nhập
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE,
                       address TEXT,
                       role VARCHAR(20) NOT NULL, -- 'PARENT', 'STUDENT', 'TEACHER', 'ADMIN'
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Thông tin Học sinh (Hồ sơ học vụ)
CREATE TABLE students (
                          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                          user_id UUID UNIQUE REFERENCES users(id) ON DELETE SET NULL, -- Liên kết đến tài khoản đăng nhập của Học sinh
                          student_code VARCHAR(20) UNIQUE NOT NULL,
                          full_name VARCHAR(100) NOT NULL,
                          date_of_birth DATE NOT NULL,
                          gender VARCHAR(10) NOT NULL,
                          avatar_url VARCHAR(255)
);

-- 3. Bảng Trung gian Liên kết Phụ huynh - Học sinh (Quan hệ Nhiều - Nhiều)
CREATE TABLE parent_student (
                                parent_id UUID REFERENCES users(id) ON DELETE CASCADE,
                                student_id UUID REFERENCES students(id) ON DELETE CASCADE,
                                PRIMARY KEY (parent_id, student_id)
);

-- 4. Bảng Lớp học
CREATE TABLE classes (
                         id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                         class_name VARCHAR(20) NOT NULL,
                         school_year VARCHAR(20) NOT NULL, -- Ví dụ: "2025-2026"
                         homeroom_teacher_id UUID REFERENCES users(id) ON DELETE SET NULL
);

-- 5. Bảng Lịch sử/Danh sách Học sinh thuộc lớp nào
CREATE TABLE student_class (
                               student_id UUID REFERENCES students(id) ON DELETE CASCADE,
                               class_id UUID REFERENCES classes(id) ON DELETE CASCADE,
                               status VARCHAR(20) DEFAULT 'ACTIVE', -- 'ACTIVE', 'GRADUATED'
                               PRIMARY KEY (student_id, class_id)
);

-- 6. Bảng Chi tiết các tiết học trong tuần (Thời khóa biểu cố định)
CREATE TABLE timetable_slots (
                                 id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                 class_id UUID REFERENCES classes(id) ON DELETE CASCADE,
                                 subject_name VARCHAR(50) NOT NULL, -- 'Toán', 'Ngữ Văn'...
                                 teacher_name VARCHAR(100),
                                 room_name VARCHAR(20), -- 'A.203'
                                 slot_number INT NOT NULL, -- Tiết 1, 2, 3, 4...
                                 day_of_week INT NOT NULL, -- 2 -> Thứ 2, 7 -> Thứ 7
                                 start_time TIME NOT NULL,
                                 end_time TIME NOT NULL
);

-- 7. Bảng Nhật ký điểm danh thực tế theo từng ngày
CREATE TABLE attendance (
                            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                            student_id UUID REFERENCES students(id) ON DELETE CASCADE,
                            slot_id UUID REFERENCES timetable_slots(id) ON DELETE CASCADE,
                            attendance_date DATE NOT NULL,
                            status VARCHAR(20) NOT NULL, -- 'ATTENDED', 'ABSENT', 'PENDING'
                            recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Bảng Điểm số thành phần & Nhận xét của giáo viên
CREATE TABLE academic_grades (
                                 id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                 student_id UUID REFERENCES students(id) ON DELETE CASCADE,
                                 subject_name VARCHAR(50) NOT NULL,
                                 semester VARCHAR(20) NOT NULL, -- 'Học kỳ I', 'Học kỳ II'
                                 school_year VARCHAR(20) NOT NULL,
                                 frequent_grades TEXT, -- Chuỗi lưu điểm thường xuyên: "8,9,7.5"
                                 midterm_grade DECIMAL(3,1),
                                 final_grade DECIMAL(3,1),
                                 overall_grade VARCHAR(10), -- Điểm tổng kết cuối cùng hoặc "Đạt"
                                 teacher_comment TEXT
);

-- 9. Bảng Danh sách Sự kiện trường tổ chức
CREATE TABLE events (
                        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                        badge VARCHAR(20) NOT NULL, -- 'Hội thảo', 'Trại hè'...
                        title VARCHAR(255) NOT NULL,
                        base64_image TEXT, -- Ảnh mã hóa chuỗi dài
                        description TEXT,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Bảng Chi tiết thông tin đi kèm sự kiện
CREATE TABLE event_property (
                                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                event_id UUID REFERENCES events(id) ON DELETE CASCADE,
                                property_name VARCHAR(50) NOT NULL, -- 'Dress Code', 'Địa điểm'
                                property_value VARCHAR(255) NOT NULL
);

-- 11. Bảng Phụ huynh đăng ký tham gia sự kiện
CREATE TABLE event_registrations (
                                     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                     event_id UUID REFERENCES events(id) ON DELETE CASCADE,
                                     parent_id UUID REFERENCES users(id) ON DELETE CASCADE,
                                     number_of_attendees INT DEFAULT 1,
                                     notes TEXT,
                                     registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. Bảng Danh sách các Câu lạc bộ
CREATE TABLE clubs (
                       id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                       club_name VARCHAR(100) NOT NULL,
                       description TEXT,
                       base64_image TEXT,
                       schedules TEXT, -- Lịch sinh hoạt định dạng JSON hoặc text tự do
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 13. Bảng Thành viên Học sinh tham gia câu lạc bộ
CREATE TABLE club_members (
                              id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                              club_id UUID REFERENCES clubs(id) ON DELETE CASCADE,
                              student_id UUID REFERENCES students(id) ON DELETE CASCADE,
                              role VARCHAR(20) DEFAULT 'MEMBER', -- 'MEMBER', 'LEADER'
                              joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Bảng Quản lý Đơn từ của Phụ huynh gửi cho con
CREATE TABLE applications (
                              id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                              student_id UUID REFERENCES students(id) ON DELETE CASCADE,
                              parent_id UUID REFERENCES users(id) ON DELETE CASCADE,
                              application_type VARCHAR(50) NOT NULL, -- 'SICK_LEAVE', 'EARLY_LEAVE'...
                              reason TEXT NOT NULL,
                              from_date DATE NOT NULL,
                              to_date DATE NOT NULL,
                              status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
                              submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================================
-- MỤC B: CÁC TÍNH NĂNG MỞ RỘNG (KHI CÒN THỜI GIAN THÌ CHẠY ĐOẠN NÀY)
-- =========================================================================

-- 15. Bảng Lưu FCM Token đẩy thông báo Push thời gian thực lên Mobile App
CREATE TABLE user_device_tokens (
                                    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
                                    device_token TEXT NOT NULL,
                                    device_type VARCHAR(10) NOT NULL, -- 'ANDROID', 'IOS'
                                    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Bảng Tin tức/Truyền thông nội bộ hiển thị động ngoài Trang chủ
CREATE TABLE school_news (
                             id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                             title VARCHAR(255) NOT NULL,
                             summary VARCHAR(500),
                             content TEXT NOT NULL, -- Nội dung bài viết dài
                             thumbnail_url VARCHAR(255),
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================================
-- MỤC C: TRUNCATE VÀ CHÈN MỚI DỮ LIỆU MẪU ĐỒNG BỘ
-- =========================================================================
DO
$$
    DECLARE
        -- UUID cho tài khoản Phụ huynh
parent1_id       UUID := '44444444-4444-4444-4444-444444444444';
        parent2_id       UUID := '55555555-5555-5555-5555-555555555555';

        -- UUID cho tài khoản Đăng nhập của Học sinh (Nằm ở bảng users)
        user_student1_id UUID := '11111111-1111-1111-1111-111111111111';
        user_student2_id UUID := '22222222-2222-2222-2222-222222222222';
        user_student3_id UUID := '33333333-3333-3333-3333-333333333333';

        -- UUID cho Hồ sơ học vụ Học sinh (Nằm ở bảng students)
        student1_id      UUID := '66666666-6666-6666-6666-666666666666';
        student2_id      UUID := '77777777-7777-7777-7777-777777777777';
        student3_id      UUID := '88888888-8888-8888-8888-888888888888';

        -- UUID cho các Lớp học
        class1_id        UUID := '99999999-9999-9999-9999-999999999999';
        class2_id        UUID := '00000000-0000-0000-0000-000000000000';

        -- UUID cho Thời khóa biểu (Gồm cả Slot lớp 4A1 và lớp 2A2)
        slot1_id         UUID := 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
        slot2_id         UUID := 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';
        slot3_id         UUID := 'cccccccc-aaaa-bbbb-cccc-dddddddddddd';
        slot4_id         UUID := 'dddddddd-aaaa-bbbb-cccc-dddddddddddd';

        event1_id        UUID := 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
        club1_id         UUID := 'ffffffff-ffff-ffff-ffff-ffffffffffff';

        -- Biến động bóc tách Thứ trong tuần của ngày hôm nay (Giá trị từ 1 -> 7 tương ứng Thứ 2 -> Chủ Nhật)
        current_day_num  INT  := EXTRACT(ISODOW FROM CURRENT_DATE)::INTEGER;
BEGIN
        -- Xóa sạch dữ liệu cũ theo đúng thứ tự ràng buộc
TRUNCATE applications, club_members, clubs, event_registrations, event_property, events,
            academic_grades, attendance, timetable_slots, student_class, classes, parent_student,
            students, users, user_device_tokens, school_news CASCADE;

-- 1. CHÈN TÀI KHOẢN ĐĂNG NHẬP (TẤT CẢ DÙNG PHONE_NUMBER)
INSERT INTO users (id, phone_number, password, full_name, email, address, role)
VALUES (parent1_id, '0395069078', 'Hieu123.', 'Thiều Văn Hiếu', 'thieuefvanwhieues@gmail.com', 'Yên Phú, Thanh Hóa', 'PARENT'),
       (parent2_id, '0944444444', 'parent123', 'Phạm Hồng Nhung', 'nhungph@gmail.com', 'Thanh Xuân, Hà Nội', 'PARENT');

INSERT INTO users (id, phone_number, password, full_name, email, address, role)
VALUES (user_student1_id, '0911111111', 'student123', 'Thiều Văn Khôi', 'khoind@fschool.edu.vn', NULL, 'STUDENT'),
       (user_student2_id, '0922222222', 'student123', 'Thiều Văn Khánh', 'khanhnd@fschool.edu.vn', NULL, 'STUDENT'),
       (user_student3_id, '0933333333', 'student123', 'Phạm Bảo Ngọc', 'ngocpb@fschool.edu.vn', NULL, 'STUDENT');

-- 2. CHÈN THÔNG TIN HỒ SƠ HỌC SINH
INSERT INTO students (id, user_id, student_code, full_name, date_of_birth, gender, avatar_url)
VALUES (student1_id, user_student1_id, 'HE190001', 'Thiều Văn Khôi', '2015-05-12', 'MALE', 'https://api.multiavatar.com/Khoi.png'),
       (student2_id, user_student2_id, 'HE190002', 'Thiều Văn Khánh', '2017-09-20', 'MALE', 'https://api.multiavatar.com/Khanh.png'),
       (student3_id, user_student3_id, 'HE190003', 'Phạm Bảo Ngọc', '2015-11-02', 'FEMALE', 'https://api.multiavatar.com/Ngoc.png');

-- 3. LIÊN KẾT PHỤ HUYNH - CON CÁI (Thiều Văn Hiếu có 2 con là Khôi và Khánh)
INSERT INTO parent_student (parent_id, student_id)
VALUES (parent1_id, student1_id),
       (parent1_id, student2_id),
       (parent2_id, student3_id);

-- 4. BẢNG LỚP HỌC
INSERT INTO classes (id, class_name, school_year, homeroom_teacher_id)
VALUES (class1_id, 'Lớp 4A1', '2025-2026', NULL),
       (class2_id, 'Lớp 2A2', '2025-2026', NULL);

-- 5. XẾP LỚP CHO HỌC SINH
INSERT INTO student_class (student_id, class_id, status)
VALUES (student1_id, class1_id, 'ACTIVE'),
       (student3_id, class1_id, 'ACTIVE'),
       (student2_id, class2_id, 'ACTIVE');

-- 6. THỜI KHÓA BIỂU CỐ ĐỊNH (Tự động gán day_of_week trùng khít với ngày hôm nay)
-- Slot Lớp 4A1 (Thiều Văn Khôi)
INSERT INTO timetable_slots (id, class_id, subject_name, teacher_name, room_name, slot_number, day_of_week, start_time, end_time)
VALUES (slot1_id, class1_id, 'Toán Học', 'Thầy Trần Văn Hoàng', 'R.401', 1, current_day_num, '08:00:00', '08:45:00'),
       (slot2_id, class1_id, 'Ngữ Văn', 'Cô Lê Thị Minh Tâm', 'R.401', 2, current_day_num, '09:00:00', '09:45:00');

-- Slot Lớp 2A2 (Thiều Văn Khánh)
INSERT INTO timetable_slots (id, class_id, subject_name, teacher_name, room_name, slot_number, day_of_week, start_time, end_time)
VALUES (slot3_id, class2_id, 'Tự Nhiên Xã Hội', 'Cô Nguyễn Minh Thư', 'R.202', 1, current_day_num, '08:00:00', '08:45:00'),
       (slot4_id, class2_id, 'Mỹ Thuật', 'Thầy Vương Gia Đạt', 'R.202', 2, current_day_num, '09:00:00', '09:45:00');

-- 7. NHẬT KÝ ĐIỂM DANH THỰC TẾ (Đổ thẳng vào CURRENT_DATE để review giao diện)
-- Bé Khôi (student1): Đã điểm danh đầy đủ
INSERT INTO attendance (student_id, slot_id, attendance_date, status)
VALUES (student1_id, slot1_id, CURRENT_DATE, 'ATTENDED'),
       (student1_id, slot2_id, CURRENT_DATE, 'ATTENDED');

-- Bạn cùng lớp Khôi (Bảo Ngọc): Vắng học
INSERT INTO attendance (student_id, slot_id, attendance_date, status)
VALUES (student3_id, slot1_id, CURRENT_DATE, 'ABSENT');

-- Bé Khánh (student2): Đưa vào trạng thái chưa điểm danh (PENDING) để tạo dữ liệu đối lập
INSERT INTO attendance (student_id, slot_id, attendance_date, status)
VALUES (student2_id, slot3_id, CURRENT_DATE, 'PENDING'),
       (student2_id, slot4_id, CURRENT_DATE, 'PENDING');

-- 8. ĐIỂM SỐ
INSERT INTO academic_grades (student_id, subject_name, semester, school_year, frequent_grades, midterm_grade, final_grade, overall_grade, teacher_comment)
VALUES (student1_id, 'Toán Học', 'Học kỳ II', '2025-2026', '9.0,8.5,10.0', 9.0, 9.5, 'A+', 'Con học toán rất tốt, tư duy logic nhanh nhẹn.'),
       (student3_id, 'Toán Học', 'Học kỳ II', '2025-2026', '8.0,8.0,7.5', 8.0, 8.5, 'A', 'Ngoan ngoãn, tập trung nghe giảng.');

-- 9. SỰ KIỆN TRƯỜNG & ĐĂNG KÝ THAM GIA
INSERT INTO events (id, badge, title, base64_image, description)
VALUES (event1_id, 'Hội Thao', 'Ngày Hội Thể Thao FSchool 2026', 'sport_img_holder', 'Ngày hội nâng cao sức khỏe thể chất cho học sinh toàn trường.');

INSERT INTO event_property (event_id, property_name, property_value)
VALUES (event1_id, 'Địa điểm', 'Sân vận động FPT Campus'),
       (event1_id, 'Thời gian', '07:30 sáng Thứ Bảy tuần này');

INSERT INTO event_registrations (event_id, parent_id, number_of_attendees, notes)
VALUES (event1_id, parent1_id, 3, 'Gia đình đăng ký chạy tiếp sức.');

-- 12. CÂU LẠC BỘ & THÀNH VIÊN
INSERT INTO clubs (id, club_name, description, base64_image, schedules)
VALUES (club1_id, 'CLB Bóng Đá Nhí', 'Rèn luyện kỹ thuật sân cỏ cơ bản.', 'soccer_holder', 'Chiều Thứ 4 (16:30 - 18:00)');

INSERT INTO club_members (club_id, student_id, role)
VALUES (club1_id, student1_id, 'MEMBER');

-- 14. ĐƠN TỪ XIN NGHỈ
INSERT INTO applications (student_id, parent_id, application_type, reason, from_date, to_date, status, submitted_at)
VALUES (student3_id, parent2_id, 'SICK_LEAVE', 'Cháu bị sốt, gia đình xin phép cho cháu nghỉ học.', CURRENT_DATE, CURRENT_DATE + INTERVAL '1 day', 'APPROVED', NOW());

-- 16. TIN TỨC TRANG CHỦ BẢNG TIN
INSERT INTO school_news (title, summary, content, thumbnail_url, created_at)
VALUES ('Thông báo Lịch nghỉ lễ', 'Lịch nghỉ lễ sắp tới dành cho học sinh.', 'Nhà trường xin thông báo lịch nghỉ lễ kéo dài 3 ngày...', 'https://fschool.edu.vn/news/1.jpg', NOW());

END $$;