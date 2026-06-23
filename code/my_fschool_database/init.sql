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
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- KÍCH HOẠT EXTENSION ĐỂ SINH SỐ UUID TỰ ĐỘNG
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- MỤC A: CẤU TRÚC BẢNG CORE LOGIC (ĐÃ REFACTOR TINH GỌN VỀ USER_CLASS)
-- =========================================================================

-- 1. Bảng Người dùng hệ thống (Chỉ quản lý thông tin Đăng nhập & Xác thực tập trung)
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

-- 2. Bảng Thông tin Hồ sơ Học sinh (Hồ sơ học vụ độc lập)
CREATE TABLE students
(
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id       UUID UNIQUE        REFERENCES users (id) ON DELETE SET NULL, -- Có thể NULL nếu học sinh nhỏ tuổi chưa có tài khoản/SĐT riêng
    student_code  VARCHAR(20) UNIQUE NOT NULL,
    full_name     VARCHAR(100)       NOT NULL,
    date_of_birth DATE               NOT NULL,
    gender        VARCHAR(10)        NOT NULL,
    avatar_url    VARCHAR(255)
);

-- 3. Bảng Lớp học
CREATE TABLE classes
(
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_name          VARCHAR(20) NOT NULL,
    school_year         VARCHAR(20) NOT NULL, -- Ví dụ: "2025-2026"
    homeroom_teacher_id UUID        REFERENCES users (id) ON DELETE SET NULL
);

-- 4. [REFACTOR TRỌNG TÂM] Bảng trung gian duy nhất quản lý không gian lớp học và vai trò của User
CREATE TABLE user_class
(
    user_id            UUID REFERENCES users (id) ON DELETE CASCADE,
    class_id           UUID REFERENCES classes (id) ON DELETE CASCADE,
    role               VARCHAR(20) NOT NULL,         -- 'STUDENT', 'PARENT'

    -- Nếu role = 'PARENT': Trường này lưu ID đứa con để biết phụ huynh quản lý ai trong lớp này.
    -- Nếu role = 'STUDENT': Trường này lưu chính ID hồ sơ học vụ của học sinh đó.
    student_profile_id UUID REFERENCES students (id) ON DELETE CASCADE,

    status             VARCHAR(20) DEFAULT 'ACTIVE', -- 'ACTIVE', 'GRADUATED'
    PRIMARY KEY (user_id, class_id, student_profile_id)
);

-- 5. Bảng Chi tiết các tiết học trong tuần (Thời khóa biểu cố định)
CREATE TABLE timetable_slots
(
    id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    class_id     UUID REFERENCES classes (id) ON DELETE CASCADE,
    subject_name VARCHAR(50) NOT NULL,
    teacher_name VARCHAR(100),
    room_name    VARCHAR(20),
    slot_number  INT         NOT NULL,
    day_of_week  INT         NOT NULL, -- 2 -> Thứ 2, 7 -> Thứ 7
    start_time   TIME        NOT NULL,
    end_time     TIME        NOT NULL
);

-- 6. Bảng Nhật ký điểm danh thực tế theo từng ngày
CREATE TABLE attendance
(
    id              UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    student_id      UUID REFERENCES students (id) ON DELETE CASCADE,
    slot_id         UUID REFERENCES timetable_slots (id) ON DELETE CASCADE,
    attendance_date DATE        NOT NULL,
    status          VARCHAR(20) NOT NULL, -- 'ATTENDED', 'ABSENT', 'PENDING'
    recorded_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Bảng Điểm số thành phần & Nhận xét của giáo viên
CREATE TABLE academic_grades
(
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id      UUID REFERENCES students (id) ON DELETE CASCADE,
    subject_name    VARCHAR(50) NOT NULL,
    subject_type    VARCHAR(20) NOT NULL, -- 🎯 THÊM MỚI: 'NUMERIC' hoặc 'QUALITATIVE'
    semester        VARCHAR(20) NOT NULL, -- 'Học kỳ I', 'Học kỳ II'
    school_year     VARCHAR(20) NOT NULL,
    frequent_grades TEXT,                 -- Chuỗi lưu điểm thường xuyên dạng số nguyên sạch: "9,8,10"
    midterm_grade   DECIMAL(3, 1),
    final_grade     DECIMAL(3, 1),
    overall_grade   VARCHAR(10),          -- Lưu "8.7" đối với NUMERIC hoặc "Đạt" đối với QUALITATIVE
    teacher_comment TEXT
);

-- 8. Bảng Danh sách Sự kiện trường tổ chức
CREATE TABLE events
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    badge        VARCHAR(20)  NOT NULL, -- 'Hội thảo', 'Trại hè'...
    title        VARCHAR(255) NOT NULL,
    base64_image TEXT,
    description  TEXT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. Bảng Chi tiết thông tin đi kèm sự kiện
CREATE TABLE event_property
(
    id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id       UUID REFERENCES events (id) ON DELETE CASCADE,
    property_name  VARCHAR(50)  NOT NULL,
    property_value VARCHAR(255) NOT NULL
);

-- 10. Bảng Phụ huynh đăng ký tham gia sự kiện
CREATE TABLE event_registrations
(
    id                  UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    event_id            UUID REFERENCES events (id) ON DELETE CASCADE,
    parent_id           UUID REFERENCES users (id) ON DELETE CASCADE,
    number_of_attendees INT                      DEFAULT 1,
    notes               TEXT,
    registered_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. Bảng Danh sách các Câu lạc bộ
CREATE TABLE clubs
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    club_name    VARCHAR(100) NOT NULL,
    description  TEXT,
    base64_image TEXT,
    schedules    TEXT,
    created_at   TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. Bảng Thành viên Học sinh tham gia câu lạc bộ
CREATE TABLE club_members
(
    id         UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    club_id    UUID REFERENCES clubs (id) ON DELETE CASCADE,
    student_id UUID REFERENCES students (id) ON DELETE CASCADE,
    role       VARCHAR(20)              DEFAULT 'MEMBER', -- 'MEMBER', 'LEADER'
    joined_at  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 13. Bảng Quản lý Đơn từ của Phụ huynh gửi cho con
CREATE TABLE applications
(
    id               UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    student_id       UUID REFERENCES students (id) ON DELETE CASCADE,
    parent_id        UUID REFERENCES users (id) ON DELETE CASCADE,
    application_type VARCHAR(50) NOT NULL,                       -- 'SICK_LEAVE', 'EARLY_LEAVE'...
    reason           TEXT        NOT NULL,
    from_date        DATE        NOT NULL,
    to_date          DATE        NOT NULL,
    status           VARCHAR(20)              DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    submitted_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- MỤC B: CÁC TÍNH NĂNG MỞ RỘNG 
-- =========================================================================

-- 14. Bảng Lưu FCM Token đẩy thông báo Push thời gian thực
CREATE TABLE user_device_tokens
(
    id           UUID PRIMARY KEY         DEFAULT uuid_generate_v4(),
    user_id      UUID REFERENCES users (id) ON DELETE CASCADE,
    device_token TEXT        NOT NULL,
    device_type  VARCHAR(10) NOT NULL, -- 'ANDROID', 'IOS'
    last_active  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 15. Bảng Tin tức hiển thị ngoài Trang chủ
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
        -- UUID tài khoản Phụ huynh
        parent1_id                 UUID := '44444444-4444-4444-4444-444444444444';
        parent2_id                 UUID := '55555555-5555-5555-5555-555555555555';

        -- UUID tài khoản đăng nhập của Học sinh (nếu có dùng app riêng)
        user_student1_id           UUID := '11111111-1111-1111-1111-111111111111';
        user_student2_id           UUID := '22222222-2222-2222-2222-222222222222';
        user_student3_id           UUID := '33333333-3333-3333-3333-333333333333';

        -- UUID cho Hồ sơ học vụ độc lập của Học sinh
        student1_id                UUID := '66666666-6666-6666-6666-666666666666';
        student2_id                UUID := '77777777-7777-7777-7777-777777777777';
        student3_id                UUID := '88888888-8888-8888-8888-888888888888';

        -- 🆕 UUID Hồ sơ học sinh cũ của chính Bố Hiếu (Phục vụ case đặc biệt)
        parent1_student_profile_id UUID := 'eeeeeeee-1111-2222-3333-ffffffffffff';

        -- UUID cho các Lớp học
        class1_id                  UUID := '99999999-9999-9999-9999-999999999999';
        class2_id                  UUID := '00000000-0000-0000-0000-000000000000';

        -- 🆕 UUID Lớp học cũ trong quá khứ của Bố Hiếu
        class_old_id               UUID := '11112222-3333-4444-5555-666677778888';

        -- UUID cho Thời khóa biểu cố định
        slot1_id                   UUID := 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
        slot2_id                   UUID := 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';
        slot3_id                   UUID := 'cccccccc-aaaa-bbbb-cccc-dddddddddddd';
        slot4_id                   UUID := 'dddddddd-aaaa-bbbb-cccc-dddddddddddd';
        event1_id                  UUID := 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
        club1_id                   UUID := 'ffffffff-ffff-ffff-ffff-ffffffffffff';

        -- Biến tính Thứ tự động của ngày hôm nay (1 -> 7 tương ứng Thứ 2 -> Chủ Nhật)
        current_day_num            INT  := EXTRACT(ISODOW FROM CURRENT_DATE)::INTEGER;
    BEGIN
        -- 1. CHÈN USERS (KHÔNG CÒN CHỨA CỘT ROLE CỐ ĐỊNH)
        INSERT INTO users (id, phone_number, password, full_name, email, address)
        VALUES (parent1_id, '0395069078', '66771508', 'Thiều Văn Hiếu', 'thieuefvanwhieues@gmail.com',
                'Yên Phú, Thanh Hóa'),
               (parent2_id, '0944444444', 'parent123', 'Phạm Hồng Nhung', 'nhungph@gmail.com', 'Thanh Xuân, Hà Nội'),
               (user_student1_id, '0911111111', 'student123', 'Thiều Văn Khôi', 'khoind@fschool.edu.vn', NULL),
               (user_student2_id, '0922222222', 'student123', 'Thiều Văn Khánh', 'khanhnd@fschool.edu.vn', NULL),
               (user_student3_id, '0933333333', 'student123', 'Phạm Bảo Ngọc', 'ngocpb@fschool.edu.vn', NULL);

        -- 2. CHÈN HỒ SƠ HỌC SINH
        INSERT INTO students (id, user_id, student_code, full_name, date_of_birth, gender, avatar_url)
        VALUES (student1_id, user_student1_id, 'HE190001', 'Thiều Văn Khôi', '2015-05-12', 'MALE',
                'https://api.multiavatar.com/Khoi.png'),
               (student2_id, user_student2_id, 'HE190002', 'Thiều Văn Khánh', '2017-09-20', 'MALE',
                'https://api.multiavatar.com/Khanh.png'),
               (student3_id, user_student3_id, 'HE190003', 'Phạm Bảo Ngọc', '2015-11-02', 'FEMALE',
                'https://api.multiavatar.com/Ngoc.png'),
               -- 🆕 Hồ sơ học sinh cũ được liên kết với user_id của Bố Hiếu
               (parent1_student_profile_id, parent1_id, 'ST199801', 'Thiều Văn Hiếu', '1998-02-24', 'MALE',
                'https://api.multiavatar.com/Hieu.png');

        -- 3. BẢNG LỚP HỌC
        INSERT INTO classes (id, class_name, school_year, homeroom_teacher_id)
        VALUES (class1_id, 'Lớp 4A1', '2025-2026', NULL),
               (class2_id, 'Lớp 2A2', '2025-2026', NULL),
               -- 🆕 Tạo thêm không gian lớp học cũ/khóa cũ để gán cho trường hợp học sinh của Bố Hiếu
               (class_old_id, 'Khóa Cựu Học Sinh', '2013-2016', NULL);

        -- 4. LIÊN KẾT PHẲNG TOÀN BỘ VAI TRÒ VÀO USER_CLASS
        INSERT INTO user_class (user_id, class_id, role, student_profile_id, status)
        VALUES
            -- Nhánh 1: Học sinh tự đăng nhập bằng tài khoản cá nhân để theo dõi không gian học vụ của chính mình
            (user_student1_id, class1_id, 'STUDENT', student1_id, 'ACTIVE'), -- Khôi tự xem lớp 4A1
            (user_student2_id, class2_id, 'STUDENT', student2_id, 'ACTIVE'), -- Khánh tự xem lớp 2A2
            (user_student3_id, class1_id, 'STUDENT', student3_id, 'ACTIVE'), -- Bảo Ngọc tự xem lớp 4A1

            -- Nhánh 2: Phụ huynh tham gia không gian lớp học để quản lý con cái
            -- Bố Hiếu quản lý 2 con ở 2 lớp khác nhau: Khôi (4A1) và Khánh (2A2)
            (parent1_id, class1_id, 'PARENT', student1_id, 'ACTIVE'),
            (parent1_id, class2_id, 'PARENT', student2_id, 'ACTIVE'),

            -- Mẹ Nhung quản lý Bảo Ngọc tại lớp 4A1
            (parent2_id, class1_id, 'PARENT', student3_id, 'ACTIVE'),

            -- 🆕 Nhánh 3 (Đặc biệt): Bố Hiếu truy cập không gian với tư cách là Cựu HỌC SINH của trường 
            -- Trạng thái để GRADUATED hoặc ACTIVE tùy thuộc việc phen muốn hiển thị lên màn hình thế nào
            (parent1_id, class_old_id, 'STUDENT', parent1_student_profile_id, 'ACTIVE');

        -- 5. THỜI KHÓA BIỂU CỐ ĐỊNH (Gán day_of_week trùng khít với ngày hôm nay để test API)
        -- Slot Lớp 4A1
        INSERT INTO timetable_slots (id, class_id, subject_name, teacher_name, room_name, slot_number, day_of_week,
                                     start_time, end_time)
        VALUES (slot1_id, class1_id, 'Toán Học', 'Thầy Trần Văn Hoàng', 'R.401', 1, current_day_num, '08:00:00',
                '08:45:00'),
               (slot2_id, class1_id, 'Ngữ Văn', 'Cô Lê Thị Minh Tâm', 'R.401', 2, current_day_num, '09:00:00',
                '09:45:00');

        -- Slot Lớp 2A2
        INSERT INTO timetable_slots (id, class_id, subject_name, teacher_name, room_name, slot_number, day_of_week,
                                     start_time, end_time)
        VALUES (slot3_id, class2_id, 'Tự Nhiên Xã Hội', 'Cô Nguyễn Minh Thư', 'R.202', 1, current_day_num, '08:00:00',
                '08:45:00'),
               (slot4_id, class2_id, 'Mỹ Thuật', 'Thầy Vương Gia Đạt', 'R.202', 2, current_day_num, '09:00:00',
                '09:45:00');

        -- 6. NHẬT KÝ ĐIỂM DANH THỰC TẾ
        INSERT INTO attendance (student_id, slot_id, attendance_date, status)
        VALUES (student1_id, slot1_id, CURRENT_DATE, 'ATTENDED'),
               (student1_id, slot2_id, CURRENT_DATE, 'ATTENDED'),
               (student3_id, slot1_id, CURRENT_DATE, 'ABSENT'),
               (student2_id, slot3_id, CURRENT_DATE, 'PENDING'),
               (student2_id, slot4_id, CURRENT_DATE, 'PENDING');

        -- 7. ĐIỂM SỐ HỌC VẬT
        INSERT INTO academic_grades (student_id, subject_name, subject_type, semester, school_year, frequent_grades,
                                     midterm_grade, final_grade, overall_grade, teacher_comment)
        VALUES
            -- Môn tính điểm (NUMERIC) - Điểm thường xuyên lưu số nguyên sạch sẽ
            (student1_id, 'Toán Học', 'NUMERIC', 'Học kỳ II', '2025-2026', '9,8,10', 9.0, 9.5, '8.7',
             'Con học toán rất tốt, tư duy logic nhanh nhẹn.'),

            -- Môn định tính (QUALITATIVE) - Không có điểm thành phần, overall_grade lưu chữ "Đạt"
            (student1_id, 'Vovinam', 'QUALITATIVE', 'Học kỳ II', '2025-2026', NULL, NULL, NULL, 'Đạt',
             'Nắm vững các tư thế tấn pháp, hoàn thành tốt bài quyền.');

        -- 8. SỰ KIỆN TRƯỜNG & ĐĂNG KÝ
        INSERT INTO events (id, badge, title, base64_image, description)
        VALUES (event1_id, 'Hội Thao', 'Ngày Hội Thể Thao FSchool 2026', 'sport_img_holder',
                'Ngày hội nâng cao sức khỏe thể chất cho học sinh toàn trường.');

        INSERT INTO event_property (event_id, property_name, property_value)
        VALUES (event1_id, 'Địa điểm', 'Sân vận động FPT Campus'),
               (event1_id, 'Thời gian', '07:30 sáng Thứ Bảy tuần này');

        INSERT INTO event_registrations (event_id, parent_id, number_of_attendees, notes)
        VALUES (event1_id, parent1_id, 3, 'Gia đình đăng ký chạy tiếp sức.');

        -- 9. CÂU LẠC BỘ & THÀNH VIÊN
        INSERT INTO clubs (id, club_name, description, base64_image, schedules)
        VALUES (club1_id, 'CLB Bóng Đá Nhí', 'Rèn luyện kỹ thuật sân cỏ cơ bản.', 'soccer_holder',
                'Chiều Thứ 4 (16:30 - 18:00)');

        INSERT INTO club_members (club_id, student_id, role)
        VALUES (club1_id, student1_id, 'MEMBER');

        -- 10. ĐƠN TỪ XIN NGHỈ HỌC
        INSERT INTO applications (student_id, parent_id, application_type, reason, from_date, to_date, status,
                                  submitted_at)
        VALUES (student3_id, parent2_id, 'SICK_LEAVE', 'Cháu bị sốt, gia đình xin phép cho cháu nghỉ học.',
                CURRENT_DATE, CURRENT_DATE + INTERVAL '1 day', 'APPROVED', NOW());

        -- 11. BẢNG TIN TRANG CHỦ
        INSERT INTO school_news (title, summary, content, thumbnail_url, created_at)
        VALUES ('Thông báo Lịch nghỉ lễ', 'Lịch nghỉ lễ sắp tới dành cho học sinh.',
                'Nhà trường xin thông báo lịch nghỉ lễ kéo dài 3 ngày...', 'https://fschool.edu.vn/news/1.jpg', NOW());

    END
$$;