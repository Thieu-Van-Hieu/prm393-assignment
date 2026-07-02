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
-- MỤC C: CHÈN MỚI DỮ LIỆU MẪU ĐỒNG BỘ - ĐÃ ƯU ÁI CHO THIỀU VĂN HIẾU (PARENT1)
-- =========================================================================
DO
$$
    DECLARE
        -- UUID cố định danh mục Roles
        role_student_id            UUID := '00000000-0000-0000-0000-000000000001';
        role_parent_id             UUID := '00000000-0000-0000-0000-000000000002';
        role_teacher_id            UUID := '00000000-0000-0000-0000-000000000003';

        -- UUID tài khoản Phụ huynh chính (Thiều Văn Hiếu) và phụ huynh phụ
        parent1_id                 UUID := '44444444-4444-4444-4444-444444444444'; -- Anh Hiếu
        parent2_id                 UUID := '55555555-5555-5555-5555-555555555555';

        -- UUID tài khoản Giáo viên
        teacher1_id                UUID := 'dddddddd-1111-1111-1111-dddddddddddd'; -- Cô Tâm
        teacher2_id                UUID := 'dddddddd-2222-2222-2222-dddddddddddd'; -- Thầy Hoàng

        -- UUID tài khoản app của Học sinh (Con anh Hiếu & Con nhà khác)
        user_student1_id           UUID := '11111111-1111-1111-1111-111111111111'; -- Khôi
        user_student2_id           UUID := '22222222-2222-2222-2222-222222222222'; -- Khánh
        user_student3_id           UUID := '33333333-3333-3333-3333-333333333333';

        -- UUID hồ sơ học vụ độc lập
        student1_id                UUID := '66666666-6666-6666-6666-666666666666'; -- Bé Khôi
        student2_id                UUID := '77777777-7777-7777-7777-777777777777'; -- Bé Khánh
        student3_id                UUID := '88888888-8888-8888-8888-888888888888';
        parent1_student_profile_id UUID := 'eeeeeeee-1111-2222-3333-ffffffffffff';

        -- UUID Lớp học
        class1_id                  UUID := '99999999-9999-9999-9999-999999999999'; -- Lớp 4A1
        class2_id                  UUID := '00000000-0000-0000-0000-000000000000'; -- Lớp 4A2
        class_old_id               UUID := '11112222-3333-4444-5555-666677778888';

        -- Các ID phục vụ Sự kiện & Câu lạc bộ
        event1_id                  UUID := 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
        event2_id                  UUID := 'eeeeeeee-eeee-eeee-eeee-222222222222';
        event3_id                  UUID := 'eeeeeeee-eeee-eeee-eeee-333333333333';
        event4_id                  UUID := 'eeeeeeee-eeee-eeee-eeee-444444444444';
        club1_id                   UUID := 'ffffffff-ffff-ffff-ffff-ffffffffffff';
        club2_id                   UUID := 'ffffffff-ffff-ffff-ffff-222222222222';
        club3_id                   UUID := 'ffffffff-ffff-ffff-ffff-333333333333';

        -- Mảng lưu ID các Slot học để chèn điểm danh tự động nhanh gọn
        slot_id_temp               UUID;
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
                'https://api.multiavatar.com/Khanh.png'),
               (student3_id, user_student3_id, 'HE190003', 'Phạm Bảo Ngọc', '2015-11-02', 'FEMALE',
                'https://api.multiavatar.com/Ngoc.png'),
               (parent1_student_profile_id, parent1_id, 'ST199801', 'Thiều Văn Hiếu', '1998-02-24', 'MALE',
                'https://api.multiavatar.com/Hieu.png');

        -- 4. BẢNG LỚP HỌC
        INSERT INTO classes (id, class_name, school_year, homeroom_teacher_id)
        VALUES (class1_id, 'Lớp 4A1', '2025-2026', teacher1_id),
               (class2_id, 'Lớp 4A2', '2025-2026', teacher2_id),
               (class_old_id, 'Khóa Cựu Học Sinh', '2013-2016', NULL);

        -- 5. KẾT NỐI VAI TRÒ QUA USER_CLASS
        INSERT INTO user_class (user_id, class_id, role_id, student_profile_id, status)
        VALUES (user_student1_id, class1_id, role_student_id, student1_id, 'ACTIVE'),
               (user_student2_id, class1_id, role_student_id, student2_id, 'ACTIVE'),
               (user_student3_id, class1_id, role_student_id, student3_id, 'ACTIVE'),
               (parent1_id, class1_id, role_parent_id, student1_id, 'ACTIVE'), -- Anh Hiếu theo dõi Khôi
               (parent1_id, class1_id, role_parent_id, student2_id, 'ACTIVE'), -- Anh Hiếu theo dõi Khánh
               (parent2_id, class1_id, role_parent_id, student3_id, 'ACTIVE'),
               (parent1_id, class_old_id, role_student_id, parent1_student_profile_id, 'ACTIVE'),
               (teacher1_id, class1_id, role_teacher_id, NULL, 'ACTIVE'),
               (teacher2_id, class2_id, role_teacher_id, NULL, 'ACTIVE');

        -- 6. THỜI KHÓA BIỂU CỐ ĐỊNH (Tạo 5 tiết/ngày xuyên suốt từ Thứ 2 đến Thứ 6 cho lớp 4A1 của con anh Hiếu)
        FOR d IN 2..6
            LOOP
                -- Ngày học của Khôi và Khánh tại lớp 4A1
                INSERT INTO timetable_slots (class_id, subject_name, teacher_id, room_name, slot_number, day_of_week,
                                             start_time, end_time)
                VALUES (class1_id, 'Toán Học', teacher2_id, 'R.401', 1, d, '08:00:00', '08:45:00'),
                       (class1_id, 'Ngữ Văn', teacher1_id, 'R.401', 2, d, '09:00:00', '09:45:00'),
                       -- 🎯 SỬA TẠI ĐÂY: Thay NULL bằng teacher1_id hoặc teacher2_id tùy bạn chọn
                       (class1_id, 'Tiếng Anh', teacher1_id, 'R.401', 3, d, '10:00:00', '10:45:00'),
                       (class1_id, 'Khoa Học', teacher2_id, 'R.401', 4, d, '14:00:00', '14:45:00'),
                       -- 🎯 SỬA TẠI ĐÂY: Thay NULL bằng teacher2_id
                       (class1_id, 'Tin Học', teacher2_id, 'Lab.01', 5, d, '15:00:00', '15:45:00');

                -- Chèn tượng trưng 1 lớp 4A2 khác để làm phong phú dữ liệu hệ thống
                INSERT INTO timetable_slots (class_id, subject_name, teacher_id, room_name, slot_number, day_of_week,
                                             start_time, end_time)
                VALUES (class2_id, 'Ngữ Văn', teacher1_id, 'R.202', 1, d, '08:00:00', '08:45:00'),
                       (class2_id, 'Toán Học', teacher2_id, 'R.202', 2, d, '09:00:00', '09:45:00');
            END LOOP;

        -- 7. NHẬT KÝ ĐIỂM DANH THỰC TẾ (Mock dữ liệu điểm danh đầy đủ cho 2 con của anh Hiếu vào ngày hôm nay)
        FOR slot_id_temp IN (SELECT id
                             FROM timetable_slots
                             WHERE class_id = class1_id
                               AND day_of_week = current_day_num)
            LOOP
                -- Bé Thiều Văn Khôi đi học đầy đủ chăm ngoan
                INSERT INTO attendance (student_id, slot_id, attendance_date, status)
                VALUES (student1_id, slot_id_temp, CURRENT_DATE, 'ATTENDED');

                -- Bé Thiều Văn Khánh trốn học tiết cuối hoặc đi muộn để test các trạng thái đa dạng trên UI
                IF (SELECT slot_number FROM timetable_slots WHERE id = slot_id_temp) = 5 THEN
                    INSERT INTO attendance (student_id, slot_id, attendance_date, status)
                    VALUES (student2_id, slot_id_temp, CURRENT_DATE, 'ABSENT');
                ELSE
                    INSERT INTO attendance (student_id, slot_id, attendance_date, status)
                    VALUES (student2_id, slot_id_temp, CURRENT_DATE, 'ATTENDED');
                END IF;
            END LOOP;

        -- 8. ĐIỂM SỐ HỌC TẬP THÀNH TÍCH CAO (Ưu ái điểm số khủng cho con anh Hiếu)
        -- Bé Thiều Văn Khôi (Toán, Văn, Anh toàn điểm xuất sắc)
        INSERT INTO academic_grades (student_id, subject_name, subject_type, semester, school_year, frequent_grades,
                                     midterm_grade, final_grade, overall_grade, teacher_id, teacher_comment)
        VALUES (student1_id, 'Toán Học', 'NUMERIC', 'Học kỳ II', '2025-2026', '10,9,10,10', 9.5, 10.0, '9.8',
                teacher2_id, 'Khôi có tư duy toán học cực đỉnh, giải toán nhanh nhất lớp.'),
               (student1_id, 'Ngữ Văn', 'NUMERIC', 'Học kỳ II', '2025-2026', '8,9,8', 8.5, 9.0, '8.6', teacher1_id,
                'Hành văn mạch lạc, chữ viết đẹp và rất có cảm xúc.'),
               (student1_id, 'Vovinam', 'QUALITATIVE', 'Học kỳ II', '2025-2026', NULL, NULL, NULL, 'Đạt', teacher1_id,
                'Tấn pháp vững vàng, có tinh thần võ đạo rất tốt.');

        -- Bé Thiều Văn Khánh (Điểm số cá tính, thiên hướng công nghệ)
        INSERT INTO academic_grades (student_id, subject_name, subject_type, semester, school_year, frequent_grades,
                                     midterm_grade, final_grade, overall_grade, teacher_id, teacher_comment)
        VALUES (student2_id, 'Toán Học', 'NUMERIC', 'Học kỳ II', '2025-2026', '9,8,9', 9.0, 8.5, '8.7', teacher2_id,
                'Nắm chắc kiến thức hình học, cần cẩn thận hơn khi tính đại số.'),
               (student2_id, 'Tin Học', 'NUMERIC', 'Học kỳ II', '2025-2026', '10,10,10', 10.0, 10.0, '10.0',
                teacher2_id, 'Thiên tài lập trình nhí! Đam mê tìm tòi thuật toán và thiết kế mạch điện.'),
               (student2_id, 'Ngữ Văn', 'NUMERIC', 'Học kỳ II', '2025-2026', '7,8,7', 7.5, 8.0, '7.6', teacher1_id,
                'Tiếp thu bài ổn, đôi lúc còn mất tập trung nói chuyện riêng.');

        -- 9. SỰ KIỆN TRƯỜNG & ĐĂNG KÝ (Anh Hiếu tham gia đăng ký hầu hết các sự kiện lớn)
        INSERT INTO events (id, badge, title, base64_image, description)
        VALUES (event1_id, 'Hội Thao', 'Ngày Hội Thể Thao FSchool 2026', 'holder',
                'Ngày hội nâng cao sức khỏe thể chất toàn trường.'),
               (event2_id, 'Hội Thảo', 'Hội Thảo Định Hướng Tương Lai Công Nghệ', 'holder',
                'Định hướng cho học sinh tiếp cận sớm với công nghệ AI và lập trình hệ thống nhúng.'),
               (event3_id, 'Triển Lãm', 'Hội Chợ Sách & Triển Lãm Mỹ Thuật Kỷ Niệm', 'holder',
                'Nơi trưng bày các sản phẩm hội họa xuất sắc của các em học sinh khối 4.'),
               (event4_id, 'Hội Rằm', 'Đêm Hội Trăng Rằm Trung Thu Đoàn Viên', 'holder',
                'Lễ hội rước đèn và phá cỗ quy mô toàn trường dành cho phụ huynh và học sinh.');

        -- Thuộc tính sự kiện
        INSERT INTO event_property (event_id, property_name, property_value)
        VALUES (event1_id, 'Địa điểm', 'Sân vận động FPT Campus'),
               (event1_id, 'Thời gian', '07:30 - Thứ Bảy tuần này'),
               (event2_id, 'Địa điểm', 'Hội trường Alpha'),
               (event2_id, 'Thời gian', '14:00 - Chiều Chủ Nhật'),
               (event3_id, 'Địa điểm', 'Sảnh tòa nhà Beta'),
               (event3_id, 'Thời gian', 'Cả ngày - Thứ Hai tuần sau'),
               (event4_id, 'Địa điểm', 'Quảng trường Trống Đồng'),
               (event4_id, 'Thời gian', '19:00 - Đêm rằm tháng 8');

        -- Đăng ký sự kiện (Ưu ái: Anh Hiếu đăng ký dồn dập nhiều sự kiện)
        INSERT INTO event_registrations (event_id, parent_id, number_of_attendees, notes)
        VALUES (event1_id, parent1_id, 3, 'Gia đình anh Thiều Văn Hiếu đăng ký chạy tiếp sức gia đình.'),
               (event2_id, parent1_id, 1, 'Bố Hiếu tham gia nghe tư vấn định hướng công nghệ IoT cho hai con.'),
               (event4_id, parent1_id, 3,
                'Gia đình chuẩn bị một mâm cỗ Trung Thu đóng góp cùng ban phụ huynh lớp 4A1.');

        -- 10. CÂU LẠC BỘ & THÀNH VIÊN (Hai con anh Hiếu nắm giữ các vị trí chủ chốt)
        INSERT INTO clubs (id, club_name, description, base64_image, schedules)
        VALUES (club1_id, 'CLB Bóng Đá Nhí', 'Nơi rèn luyện thể lực, tư duy chiến thuật sân cỏ cơ bản.',
                'holder', 'Chiều Thứ 4 (16:30 - 18:00)'),
               (club2_id, 'CLB Robotics & IoT',
                'Lắp ráp mô hình vi điều khiển, cảm biến thông minh và tư duy code khối Scratch.', 'holder',
                'Sáng Thứ 7 (09:00 - 11:00)'),
               (club3_id, 'CLB Mỹ Thuật Sáng Tạo', 'Phát triển tài năng hội họa, vẽ tranh sơn dầu và điêu khắc.',
                'holder', 'Chiều Thứ 6 (16:30 - 18:00)');

        -- Gán chức vụ hoành tráng cho con anh Hiếu
        INSERT INTO club_members (club_id, student_id, role)
        VALUES (club1_id, student1_id, 'MEMBER'), -- Khôi tham gia CLB Bóng đá
               (club2_id, student1_id, 'LEADER'), -- Khôi làm Đội trưởng/Leader CLB Robotics & IoT
               (club1_id, student2_id, 'LEADER'), -- Khánh làm Đội trưởng CLB Bóng Đá Nhí luôn
               (club2_id, student2_id, 'MEMBER');
        -- Khánh cũng tham gia học Robotics chung với anh trai

        -- 11. ĐƠN TỪ QUẢN LÝ (Đa dạng mọi trạng thái đơn từ mang tên anh Hiếu gửi lên)
        INSERT INTO applications (student_id, parent_id, application_type, reason, from_date, to_date, status,
                                  handler_id, school_response, submitted_at, processed_at)
        VALUES
            -- Đơn đã được Giáo viên phê duyệt thành công (APPROVED)
            (student1_id, parent1_id, 'SICK_LEAVE',
             'Cháu Thiều Văn Khôi bị sốt phát ban, gia đình xin phép cô Tâm cho cháu nghỉ học 1 ngày để theo dõi tại nhà.',
             '2026-05-10', '2026-05-10', 'APPROVED', teacher1_id,
             'Cô Tâm đã nhận được đơn của anh Hiếu. Nhà trường xác nhận cho cháu nghỉ và sẽ hỗ trợ gửi bài tập bổ sung sau.',
             '2026-05-09 20:15:00', '2026-05-09 21:30:00'),

            -- Đơn xin dời lịch kiểm tra đang chờ xử lý trên hệ thống (PENDING)
            (student2_id, parent1_id, 'EXAM_RESCHEDULE',
             'Cháu Thiều Văn Khánh có lịch tham gia giải đấu cờ vua trẻ cấp tỉnh trùng ngày kiểm tra Tin Học, phụ huynh xin phép được xin thi bù.',
             NULL, NULL, 'PENDING', NULL, NULL, NOW() - INTERVAL '4 hours', NULL),

            -- Đơn xin nghỉ phép đi việc gia đình đang chờ duyệt (PENDING)
            (student1_id, parent1_id, 'PERSONAL_LEAVE',
             'Gia đình có chuyến đi quan trọng về quê viếng tổ tiên dòng họ Thiều tại Yên Phú, Thanh Hóa. Tôi xin phép cho hai con nghỉ học 2 ngày.',
             '2026-07-10', '2026-07-11', 'PENDING', NULL, NULL, NOW(), NULL),

            -- Đơn bị nhà trường từ chối để làm dữ liệu mẫu phong phú (REJECTED)
            (student2_id, parent1_id, 'ACTIVITY_EXEMPTION',
             'Xin miễn hoàn toàn học phí bộ môn thể chất Vovinam học kỳ này do gia đình tự đầu tư dạy võ riêng bên ngoài.',
             NULL, NULL, 'REJECTED', teacher1_id,
             'Yêu cầu từ chối. Môn võ Vovinam là bộ môn bắt buộc trong chương trình giáo dục toàn diện của hệ thống FSchool.',
             NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day');

        -- 12. BẢNG TIN TRANG CHỦ HỆ THỐNG
        INSERT INTO school_news (title, summary, content, thumbnail_url, created_at)
        VALUES ('Thông báo Lịch nghỉ lễ Quốc Khánh',
                'Lịch nghỉ lễ sắp tới dành cho toàn bộ học sinh và cán bộ nhân viên FSchool.',
                'Nhà trường xin thông báo lịch nghỉ lễ kéo dài từ ngày...', 'https://fschool.edu.vn/news/1.jpg', NOW()),
               ('Khai mạc Siêu Cúp Bóng Đá FSchool Cup 2026',
                'Chào mừng giải đấu thường niên lớn nhất hành tinh dành cho lứa tuổi tiểu học.',
                'Giải đấu chính thức bắt đầu, hứa hẹn màn tranh tài nảy lửa từ các đội bóng mạnh, đặc biệt là sự góp mặt của Đội trưởng Thiều Văn Khánh lớp 4A1...',
                'https://fschool.edu.vn/news/2.jpg', NOW());

    END
$$;