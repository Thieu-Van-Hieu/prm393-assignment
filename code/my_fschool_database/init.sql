-- KÍCH HOẠT EXTENSION ĐỂ SINH SỐ UUID TỰ ĐỘNG
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- MỤC A: CẤU TRÚC BẢNG CORE LOGIC (TRIỂN KHAI TRƯỚC)
-- =========================================================================

-- 1. Bảng Người dùng (Phụ huynh, Giáo viên, Admin)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    role VARCHAR(20) NOT NULL, -- 'PARENT', 'TEACHER', 'ADMIN'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Thông tin Học sinh
CREATE TABLE students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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
