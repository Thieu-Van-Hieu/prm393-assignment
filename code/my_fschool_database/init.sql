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
DROP TABLE IF EXISTS user_class CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- KÍCH HOẠT EXTENSION ĐỂ SINH SỐ UUID TỰ ĐỘNG
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- MỤC A: CẤU TRÚC BẢNG CORE LOGIC
-- =========================================================================

-- 1. Bảng Người dùng hệ thống (Authentication & Core Identity)
CREATE TABLE users
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password     VARCHAR(255)       NOT NULL,
    full_name    VARCHAR(100)       NOT NULL,
    email        VARCHAR(100) UNIQUE,
    address      TEXT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Danh mục Vai trò Hệ thống (Tích hợp Spring Security GrantedAuthority)
CREATE TABLE roles
(
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name   VARCHAR(50) UNIQUE NOT NULL, -- 'STUDENT', 'PARENT', 'TEACHER', 'ADMIN'
    description VARCHAR(255)
);

-- 3. Bảng Thông tin Hồ sơ Học sinh (Hồ sơ học vụ độc lập)
CREATE TABLE students
(
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id       UUID UNIQUE        REFERENCES users (id) ON DELETE SET NULL, -- NULL nếu học sinh chưa cần acc riêng
    student_code  VARCHAR(20) UNIQUE NOT NULL,
    full_name     VARCHAR(100)       NOT NULL,
    date_of_birth DATE               NOT NULL,
    gender        VARCHAR(10)        NOT NULL,
    avatar_url    VARCHAR(255)
);

-- 4. Bảng Lớp học (Đã liên kết Giáo viên chủ nhiệm)
CREATE TABLE classes
(
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_name          VARCHAR(20) NOT NULL,
    school_year         VARCHAR(20) NOT NULL,                                -- Ví dụ: "2025-2026"
    homeroom_teacher_id UUID        REFERENCES users (id) ON DELETE SET NULL -- FK hướng tới Giáo viên chủ nhiệm
);

-- 5. Bảng trung gian quản lý Không gian lớp học và Vai trò liên kết phẳng
CREATE TABLE user_class
(
    id                 UUID PRIMARY KEY DEFAULT uuid_generate_v4(),     -- Khóa chính nhân tạo tự sinh
    user_id            UUID REFERENCES users (id) ON DELETE CASCADE,
    class_id           UUID REFERENCES classes (id) ON DELETE CASCADE,
    role_id            UUID REFERENCES roles (id) ON DELETE CASCADE,
    student_profile_id UUID REFERENCES students (id) ON DELETE CASCADE, -- Cho phép NULL đối với Giáo viên/Nhân viên

    status             VARCHAR(20)      DEFAULT 'ACTIVE'                -- 'ACTIVE', 'GRADUATED'
);

-- 🎯 THIẾT LẬP INDEX PHÂN TÁCH ĐIỀU KIỆN (Xử lý trường hợp song sinh cùng lớp & Giáo viên nhập lớp)
-- Index 1: Tránh trùng lặp với Phụ huynh và Học sinh (Bắt buộc unique khi có con)
CREATE UNIQUE INDEX uq_user_class_student_parent
    ON user_class (user_id, class_id, role_id, student_profile_id)
    WHERE student_profile_id IS NOT NULL;

-- Index 2: Tránh trùng lặp với Giáo viên (Unique theo người-lớp-role khi hồ sơ con trống)
CREATE UNIQUE INDEX uq_user_class_teacher
    ON user_class (user_id, class_id, role_id)
    WHERE student_profile_id IS NULL;


-- 6. Bảng Chi tiết các tiết học trong tuần (Thời khóa biểu cố định - Đã khử hardcode Giáo viên)
CREATE TABLE timetable_slots
(
    id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_id     UUID REFERENCES classes (id) ON DELETE CASCADE,
    subject_name VARCHAR(50) NOT NULL,
    teacher_id   UUID        REFERENCES users (id) ON DELETE SET NULL, -- FK nối trực tiếp tới bảng users
    room_name    VARCHAR(20),
    slot_number  INT         NOT NULL,
    day_of_week  INT         NOT NULL,                                 -- 2 -> Thứ 2, 7 -> Thứ 7
    start_time   TIME        NOT NULL,
    end_time     TIME        NOT NULL
);

-- 7. Bảng Nhật ký điểm danh thực tế theo từng ngày
CREATE TABLE attendance
(
    id              UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    student_id      UUID REFERENCES students (id) ON DELETE CASCADE,
    slot_id         UUID REFERENCES timetable_slots (id) ON DELETE CASCADE,
    attendance_date DATE        NOT NULL,
    status          VARCHAR(20) NOT NULL, -- 'ATTENDED', 'ABSENT', 'PENDING'
    recorded_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Bảng Điểm số thành phần & Nhận xét (Đã khử hardcode người chấm điểm)
CREATE TABLE academic_grades
(
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id      UUID REFERENCES students (id) ON DELETE CASCADE,
    subject_name    VARCHAR(50) NOT NULL,
    subject_type    VARCHAR(20) NOT NULL,                                 -- 'NUMERIC' hoặc 'QUALITATIVE'
    semester        VARCHAR(20) NOT NULL,                                 -- 'Học kỳ I', 'Học kỳ II'
    school_year     VARCHAR(20) NOT NULL,
    frequent_grades TEXT,                                                 -- Chuỗi lưu điểm thành phần: "9,8,10"
    midterm_grade   DECIMAL(3, 1),
    final_grade     DECIMAL(3, 1),
    overall_grade   VARCHAR(10),                                          -- "8.7" hoặc "Đạt"
    teacher_id      UUID        REFERENCES users (id) ON DELETE SET NULL, -- Lưu vết giáo viên nhập điểm
    teacher_comment TEXT
);

-- 9. Bảng Danh sách Sự kiện của trường tổ chức
CREATE TABLE events
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    badge        VARCHAR(20)  NOT NULL, -- 'Hội thảo', 'Hội thao'...
    title        VARCHAR(255) NOT NULL,
    base64_image TEXT,
    description  TEXT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. Bảng Chi tiết thông tin đi kèm sự kiện
CREATE TABLE event_property
(
    id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id       UUID REFERENCES events (id) ON DELETE CASCADE,
    property_name  VARCHAR(50)  NOT NULL,
    property_value VARCHAR(255) NOT NULL
);

-- 11. Bảng Phụ huynh đăng ký tham gia sự kiện trường
CREATE TABLE event_registrations
(
    id                  UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    event_id            UUID REFERENCES events (id) ON DELETE CASCADE,
    parent_id           UUID REFERENCES users (id) ON DELETE CASCADE,
    number_of_attendees INT                      DEFAULT 1,
    notes               TEXT,
    registered_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. Bảng Danh sách các Câu lạc bộ ngoại khóa
CREATE TABLE clubs
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    club_name    VARCHAR(100) NOT NULL,
    description  TEXT,
    base64_image TEXT,
    schedules    TEXT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 13. Bảng Thành viên Học sinh tham gia câu lạc bộ
CREATE TABLE club_members
(
    id         UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    club_id    UUID REFERENCES clubs (id) ON DELETE CASCADE,
    student_id UUID REFERENCES students (id) ON DELETE CASCADE,
    role       VARCHAR(20)              DEFAULT 'MEMBER', -- 'MEMBER', 'LEADER'
    joined_at  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 14. Bảng Quản lý Đơn từ (Đã lưu vết Người xử lý phục vụ Hội đồng phản biện)
CREATE TABLE applications
(
    id               UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    student_id       UUID REFERENCES students (id) ON DELETE CASCADE,
    parent_id        UUID REFERENCES users (id) ON DELETE CASCADE,
    application_type VARCHAR(50) NOT NULL,                                 -- 'SICK_LEAVE', 'ACTIVITY_EXEMPTION'...
    reason           TEXT        NOT NULL,
    from_date        DATE,                                                 -- NULL nếu là đơn chuyên biệt khác
    to_date          DATE,                                                 -- NULL nếu là đơn chuyên biệt khác
    status           VARCHAR(20)              DEFAULT 'PENDING',           -- 'PENDING', 'APPROVED', 'REJECTED'
    handler_id       UUID        REFERENCES users (id) ON DELETE SET NULL, -- 🎯 Lưu vết chính danh tài khoản Giáo viên/Nhân viên duyệt đơn
    school_response  TEXT,                                                 -- Phản hồi hiển thị text xanh trên UI
    submitted_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_at     TIMESTAMP WITH TIME ZONE                              -- Thời điểm đơn được duyệt/từ chối
);

-- =========================================================================
-- MỤC B: CÁC TÍNH NĂNG MỞ RỘNG
-- =========================================================================

-- 15. Bảng Lưu FCM Token đẩy thông báo Push
CREATE TABLE user_device_tokens
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    user_id      UUID REFERENCES users (id) ON DELETE CASCADE,
    device_token TEXT        NOT NULL,
    device_type  VARCHAR(10) NOT NULL, -- 'ANDROID', 'IOS'
    last_active  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 16. Bảng Tin tức hiển thị ngoài Trang chủ ứng dụng
CREATE TABLE school_news
(
    id            UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    title         VARCHAR(255) NOT NULL,
    summary       VARCHAR(500),
    content       TEXT         NOT NULL,
    thumbnail_url VARCHAR(255),
    created_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- MỤC C: CHÈN MỚI DỮ LIỆU MẪU ĐỒNG BỘ THEO KIẾN TRÚC MỚI
-- =========================================================================
DO
$$
    DECLARE
        -- UUID cố định danh mục Roles
        role_student_id            UUID := '00000000-0000-0000-0000-000000000001';
        role_parent_id             UUID := '00000000-0000-0000-0000-000000000002';
        role_teacher_id            UUID := '00000000-0000-0000-0000-000000000003';

        -- UUID tài khoản Phụ huynh
        parent1_id                 UUID := '44444444-4444-4444-4444-444444444444';
        parent2_id                 UUID := '55555555-5555-5555-5555-555555555555';

        -- UUID tài khoản Giáo viên mẫu
        teacher1_id                UUID := 'dddddddd-1111-1111-1111-dddddddddddd'; -- Cô Tâm
        teacher2_id                UUID := 'dddddddd-2222-2222-2222-dddddddddddd'; -- Thầy Hoàng

        -- UUID tài khoản app của Học sinh (nếu có đăng nhập)
        user_student1_id           UUID := '11111111-1111-1111-1111-111111111111';
        user_student2_id           UUID := '22222222-2222-2222-2222-222222222222';
        user_student3_id           UUID := '33333333-3333-3333-3333-333333333333';

        -- UUID hồ sơ học vụ độc lập
        student1_id                UUID := '66666666-6666-6666-6666-666666666666'; -- Bé Khôi (Con bố Hiếu)
        student2_id                UUID := '77777777-7777-7777-7777-777777777777'; -- Bé Khánh (Con bố Hiếu - Song sinh hoặc cùng lớp/khác lớp)
        student3_id                UUID := '88888888-8888-8888-8888-888888888888'; -- Bé Ngọc (Con mẹ Nhung)
        parent1_student_profile_id UUID := 'eeeeeeee-1111-2222-3333-ffffffffffff'; -- Hồ sơ cựu học sinh của chính bố Hiếu ngày xưa

        -- UUID Lớp học
        class1_id                  UUID := '99999999-9999-9999-9999-999999999999'; -- Lớp 4A1
        class2_id                  UUID := '00000000-0000-0000-0000-000000000000'; -- Lớp 4A2 (Giả định cặp song sinh học chung 4A1 luôn để test index)
        class_old_id               UUID := '11112222-3333-4444-5555-666677778888';

        -- UUID Thời khóa biểu, sự kiện, CLB
        slot1_id                   UUID := 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
        slot2_id                   UUID := 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';
        slot3_id                   UUID := 'cccccccc-aaaa-bbbb-cccc-dddddddddddd';
        slot4_id                   UUID := 'dddddddd-aaaa-bbbb-cccc-dddddddddddd';
        event1_id                  UUID := 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
        club1_id                   UUID := 'ffffffff-ffff-ffff-ffff-ffffffffffff';
        current_day_num            INT  := EXTRACT(ISODOW FROM CURRENT_DATE)::INTEGER;
    BEGIN
        -- 1. CHÈN ROLES
        INSERT INTO roles (id, role_name, description)
        VALUES (role_student_id, 'STUDENT', 'Học sinh sinh hoạt học vụ trong lớp'),
               (role_parent_id, 'PARENT', 'Phụ huynh quản lý con cái trong lớp'),
               (role_teacher_id, 'TEACHER', 'Giáo viên quản lý/giảng dạy lớp học');

        -- 2. CHÈN USERS 
        INSERT INTO users (id, phone_number, password, full_name, email, address)
        VALUES (parent1_id, '0395069078', '66771508', 'Thiều Văn Hiếu', 'thieuefvanwhieues@gmail.com',
                'Yên Phú, Thanh Hóa'),
               (parent2_id, '0944444444', 'parent123', 'Phạm Hồng Nhung', 'nhungph@gmail.com', 'Thanh Xuân, Hà Nội'),
               (teacher1_id, '0988888888', 'teacher123', 'Cô Lê Thị Minh Tâm', 'tamltm@fschool.edu.vn',
                'Cầu Giấy, Hà Nội'),
               (teacher2_id, '0977777777', 'teacher123', 'Thầy Trần Văn Hoàng', 'hoangtv@fschool.edu.vn',
                'Nam Từ Liêm, Hà Nội'),
               (user_student1_id, '0911111111', 'student123', 'Thiều Văn Khôi', 'khoind@fschool.edu.vn', NULL),
               (user_student2_id, '0922222222', 'student123', 'Thiều Văn Khánh', 'khanhnd@fschool.edu.vn', NULL),
               (user_student3_id, '0933333333', 'student123', 'Phạm Bảo Ngọc', 'ngocpb@fschool.edu.vn', NULL);

        -- 3. CHÈN HỒ SƠ HỌC SINH
        INSERT INTO students (id, user_id, student_code, full_name, date_of_birth, gender, avatar_url)
        VALUES (student1_id, user_student1_id, 'HE190001', 'Thiều Văn Khôi', '2015-05-12', 'MALE',
                'https://api.multiavatar.com/Khoi.png'),
               (student2_id, user_student2_id, 'HE190002', 'Thiều Văn Khánh', '2015-05-12', 'MALE',
                'https://api.multiavatar.com/Khanh.png'), -- Cặp song sinh Khôi - Khánh
               (student3_id, user_student3_id, 'HE190003', 'Phạm Bảo Ngọc', '2015-11-02', 'FEMALE',
                'https://api.multiavatar.com/Ngoc.png'),
               (parent1_student_profile_id, parent1_id, 'ST199801', 'Thiều Văn Hiếu', '1998-02-24', 'MALE',
                'https://api.multiavatar.com/Hieu.png');

        -- 4. BẢNG LỚP HỌC (Gán cô Tâm làm GVCN lớp 4A1)
        INSERT INTO classes (id, class_name, school_year, homeroom_teacher_id)
        VALUES (class1_id, 'Lớp 4A1', '2025-2026', teacher1_id),
               (class2_id, 'Lớp 4A2', '2025-2026', NULL),
               (class_old_id, 'Khóa Cựu Học Sinh', '2013-2016', NULL);

        -- 5. KẾT NỐI VAI TRÒ QUA USER_CLASS (ĐÃ FIX LỖI TRÙNG LỚP CHO AE SONG SINH)
        INSERT INTO user_class (user_id, class_id, role_id, student_profile_id, status)
        VALUES (user_student1_id, class1_id, role_student_id, student1_id, 'ACTIVE'),
               (user_student2_id, class1_id, role_student_id, student2_id,
                'ACTIVE'), -- Bé Khánh học cùng lớp 4A1 với anh trai Khôi
               (user_student3_id, class1_id, role_student_id, student3_id, 'ACTIVE'),

               -- 🎯 CASE SONG SINH CÙNG LỚP 4A1: Bố Hiếu quản lý song song 2 con độc lập mượt mà không trùng PK
               (parent1_id, class1_id, role_parent_id, student1_id, 'ACTIVE'),
               (parent1_id, class1_id, role_parent_id, student2_id, 'ACTIVE'),

               (parent2_id, class1_id, role_parent_id, student3_id, 'ACTIVE'),
               (parent1_id, class_old_id, role_student_id, parent1_student_profile_id, 'ACTIVE'),

               -- 🎯 CASE GIÁO VIÊN VÀO LỚP: Cô Tâm nhận lớp 4A1 với profile học sinh = NULL ngon lành cành đào
               (teacher1_id, class1_id, role_teacher_id, NULL, 'ACTIVE');

        -- 6. THỜI KHÓA BIỂU CỐ ĐỊNH (Đã map ID Giáo viên từ users)
        INSERT INTO timetable_slots (id, class_id, subject_name, teacher_id, room_name, slot_number, day_of_week,
                                     start_time, end_time)
        VALUES (slot1_id, class1_id, 'Toán Học', teacher2_id, 'R.401', 1, current_day_num, '08:00:00',
                '08:45:00'), -- Thầy Hoàng dạy
               (slot2_id, class1_id, 'Ngữ Văn', teacher1_id, 'R.401', 2, current_day_num, '09:00:00',
                '09:45:00'), -- Cô Tâm dạy
               (slot3_id, class2_id, 'Tự Nhiên Xã Hội', NULL, 'R.202', 1, current_day_num, '08:00:00', '08:45:00'),
               (slot4_id, class2_id, 'Mỹ Thuật', NULL, 'R.202', 2, current_day_num, '09:00:00', '09:45:00');

        -- 7. NHẬT KÝ ĐIỂM DANH THỰC TẾ
        INSERT INTO attendance (student_id, slot_id, attendance_date, status)
        VALUES (student1_id, slot1_id, CURRENT_DATE, 'ATTENDED'),
               (student1_id, slot2_id, CURRENT_DATE, 'ATTENDED'),
               (student3_id, slot1_id, CURRENT_DATE, 'ABSENT'),
               (student2_id, slot1_id, CURRENT_DATE, 'PENDING');

        -- 8. ĐIỂM SỐ HỌC TẬP (Lưu vết ID giáo viên chấm nhận xét)
        INSERT INTO academic_grades (student_id, subject_name, subject_type, semester, school_year, frequent_grades,
                                     midterm_grade, final_grade, overall_grade, teacher_id, teacher_comment)
        VALUES (student1_id, 'Toán Học', 'NUMERIC', 'Học kỳ II', '2025-2026', '9,8,10', 9.0, 9.5, '8.7', teacher2_id,
                'Con học toán rất tốt, tư duy logic nhanh nhẹn.'),
               (student1_id, 'Vovinam', 'QUALITATIVE', 'Học kỳ II', '2025-2026', NULL, NULL, NULL, 'Đạt', teacher1_id,
                'Nắm vững các tư thế tấn pháp, hoàn thành tốt bài quyền.');

        -- 9. SỰ KIỆN TRƯỜNG & ĐĂNG KÝ
        INSERT INTO events (id, badge, title, base64_image, description)
        VALUES (event1_id, 'Hội Thao', 'Ngày Hội Thể Thao FSchool 2026', 'sport_img_holder',
                'Ngày hội nâng cao sức khỏe thể chất cho học sinh toàn trường.');

        INSERT INTO event_property (event_id, property_name, property_value)
        VALUES (event1_id, 'Địa điểm', 'Sân vận động FPT Campus'),
               (event1_id, 'Thời gian', '07:30 sáng Thứ Bảy tuần này');

        INSERT INTO event_registrations (event_id, parent_id, number_of_attendees, notes)
        VALUES (event1_id, parent1_id, 3, 'Gia đình đăng ký chạy tiếp sức.');

        -- 10. CÂU LẠC BỘ & THÀNH VIÊN
        INSERT INTO clubs (id, club_name, description, base64_image, schedules)
        VALUES (club1_id, 'CLB Bóng Đá Nhí', 'Rèn luyện kỹ thuật sân cỏ cơ bản.', 'soccer_holder',
                'Chiều Thứ 4 (16:30 - 18:00)');

        INSERT INTO club_members (club_id, student_id, role)
        VALUES (club1_id, student1_id, 'MEMBER');

        -- 11. ĐƠN TỪ XIN NGHỈ HỌC (Đã cấu trúc gán handler_id chứng minh vết duyệt của GV)
        INSERT INTO applications (student_id, parent_id, application_type, reason, from_date, to_date, status,
                                  handler_id, school_response, submitted_at, processed_at)
        VALUES (student3_id, parent2_id, 'SICK_LEAVE',
                'Con bị sốt cao từ đêm qua, gia đình đưa con đi khám tại bệnh viện nên xin phép cho con nghỉ học ngày 31/5/2026.',
                '2026-05-31', '2026-05-31', 'APPROVED', teacher1_id,
                'Nhà trường đã nhận được thông tin và xác nhận đơn xin nghỉ.', '2026-05-30 14:20:00',
                '2026-05-30 16:45:00'),

               (student3_id, parent2_id, 'ACTIVITY_EXEMPTION',
                'Con vừa trải qua phẫu thuật dây chằng đầu gối, gia đình xin phép cho con miễn tham gia thực hành bộ môn Vovinam kỳ này.',
                NULL, NULL, 'PENDING', NULL,
                NULL, '2026-05-31 08:10:00', NULL);

        -- 12. BẢNG TIN TRANG CHỦ
        INSERT INTO school_news (title, summary, content, thumbnail_url, created_at)
        VALUES ('Thông báo Lịch nghỉ lễ', 'Lịch nghỉ lễ sắp tới dành cho học sinh.',
                'Nhà trường xin thông báo lịch nghỉ lễ kéo dài 3 ngày...', 'https://fschool.edu.vn/news/1.jpg', NOW());

    END
$$;