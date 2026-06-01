# ĐẶC TẢ HỆ THỐNG DỮ LIỆU & API - FPT SCHOOL LINK

---

## MỤC A: CẤU TRÚC CORE LOGIC (TRIỂN KHAI TRƯỚC)

Tập trung 100% vào việc phục vụ các tính năng hiển thị dữ liệu học tập cốt lõi và tương tác trực tiếp (Điểm, Điểm danh, Đơn từ, Sự kiện, Câu lạc bộ).

### I. Hệ thống các Bảng Cơ sở dữ liệu (PostgreSQL)

#### 1. Nhóm Quản lý Người dùng & Phân quyền

##### `users` (Tài khoản đăng nhập hệ thống)

* `id`: `UUID` (Primary Key)
* `phone_number`: `VARCHAR(15)` (Unique - Username đăng nhập)
* `password`: `VARCHAR(255)` (Mật khẩu mã hóa BCrypt)
* `full_name`: `VARCHAR(100)`
* `email`: `VARCHAR(100)` (Unique)
* `address`: `TEXT`
* `role`: `VARCHAR(20)` (`PARENT`, `TEACHER`, `ADMIN`)
* `created_at` / `updated_at`: `TIMESTAMP`

##### `parent_student` (Bảng trung gian liên kết Phụ huynh - Học sinh)

* `parent_id`: `UUID` (Foreign Key $\rightarrow$ `users.id`)
* `student_id`: `UUID` (Foreign Key $\rightarrow$ `students.id`)
* *Primary Key:* Khóa chính tổ hợp (`parent_id`, `student_id`)

#### 2. Nhóm Quản lý Học sinh & Lớp học

##### `students` (Thông tin học sinh)

* `id`: `UUID` (Primary Key)
* `student_code`: `VARCHAR(20)` (Unique - Ví dụ: HS202601)
* `full_name`: `VARCHAR(100)`
* `date_of_birth`: `DATE`
* `gender`: `VARCHAR(10)`
* `avatar_url`: `VARCHAR(255)`

##### `classes` (Thông tin lớp học)

* `id`: `UUID` (Primary Key)
* `class_name`: `VARCHAR(20)` (Ví dụ: 10A1, 11B2)
* `school_year`: `VARCHAR(20)` (Ví dụ: "2025-2026")
* `homeroom_teacher_id`: `UUID` (Foreign Key $\rightarrow$ `users.id`)

##### `student_class` (Danh sách học sinh thuộc lớp nào)

* `student_id`: `UUID` (Foreign Key $\rightarrow$ `students.id`)
* `class_id`: `UUID` (Foreign Key $\rightarrow$ `classes.id`)
* `status`: `VARCHAR(20)` (`ACTIVE`, `GRADUATED`)

#### 3. Nhóm Học tập: Thời khóa biểu & Điểm danh

##### `timetable_slots` (Chi tiết các tiết học cố định trong tuần)

* `id`: `UUID` (Primary Key)
* `class_id`: `UUID` (Foreign Key $\rightarrow$ `classes.id`)
* `subject_name`: `VARCHAR(50)` (Toán, Ngữ Văn, Tiếng Anh, Vovinam...)
* `teacher_name`: `VARCHAR(100)`
* `room_name`: `VARCHAR(20)` (Ví dụ: A.203)
* `slot_number`: `INT` (Tiết 1, Tiết 2, Tiết 3...)
* `day_of_week`: `INT` (2 $\rightarrow$ Thứ hai, 7 $\rightarrow$ Thứ bảy)
* `start_time`, `end_time`: `TIME`

##### `attendance` (Nhật ký điểm danh thực tế theo từng ngày)

* `id`: `UUID` (Primary Key)
* `student_id`: `UUID` (Foreign Key $\rightarrow$ `students.id`)
* `slot_id`: `UUID` (Foreign Key $\rightarrow$ `timetable_slots.id`)
* `attendance_date`: `DATE`
* `status`: `VARCHAR(20)` (`ATTENDED`, `ABSENT`, `PENDING`)
* `recorded_at`: `TIMESTAMP` (Thời gian ghi nhận hệ thống)

#### 4. Nhóm Bảng điểm & Nhận xét

##### `academic_grades` (Điểm số thành phần của học sinh)

* `id`: `UUID` (Primary Key)
* `student_id`: `UUID` (Foreign Key $\rightarrow$ `students.id`)
* `subject_name`: `VARCHAR(50)`
* `semester`: `VARCHAR(20)` (Học kỳ I, Học kỳ II)
* `school_year`: `VARCHAR(20)` (Ví dụ: 2025-2026)
* `frequent_grades`: `TEXT` (Chuỗi lưu điểm thường xuyên: "8,9,7.5")
* `midterm_grade`, `final_grade`: `DECIMAL(3,1)`
* `overall_grade`: `VARCHAR(10)` (Điểm tổng kết hoặc trạng thái "Đạt")
* `teacher_comment`: `TEXT` (Lời phê của giáo viên)

#### 5. Nhóm Sự kiện & Đăng ký tham gia

##### `events` (Danh sách sự kiện nhà trường tổ chức)

* `id`: `UUID` (Primary Key)
* `badge`: `VARCHAR(20)` (Hội thảo, Trại hè, Cuộc thi...)
* `title`: `VARCHAR(255)`
* `base64_image`: `TEXT` (Ảnh banner sự kiện hiển thị trên UI)
* `description`: `TEXT`
* `created_at`: `TIMESTAMP`

##### `event_property` (Thông tin chi tiết mở rộng của sự kiện)

* `id`: `UUID` (Primary Key)
* `event_id`: `UUID` (Foreign Key $\rightarrow$ `events.id` ON DELETE CASCADE)
* `property_name`: `VARCHAR(50)` (Dress Code, Địa điểm, Đối tượng...)
* `property_value`: `VARCHAR(255)`

##### `event_registrations` (Danh sách phụ huynh đăng ký tham gia sự kiện)

* `id`: `UUID` (Primary Key)
* `event_id`: `UUID` (Foreign Key $\rightarrow$ `events.id`)
* `parent_id`: `UUID` (Foreign Key $\rightarrow$ `users.id`)
* `number_of_attendees`: `INT` (Số người đi cùng)
* `notes`: `TEXT`
* `registered_at`: `TIMESTAMP`

#### 6. Nhóm Quản lý Câu lạc bộ (Clubs)

##### `clubs` (Danh sách các câu lạc bộ trong trường)

* `id`: `UUID` (Primary Key)
* `club_name`: `VARCHAR(100)`
* `description`: `TEXT`
* `base64_image`: `TEXT`
* `schedules`: `TEXT` (Lịch sinh hoạt cố định dạng Markdown hoặc JSON)
* `created_at`: `TIMESTAMP`

##### `club_members` (Danh sách học sinh tham gia câu lạc bộ)

* `id`: `UUID` (Primary Key)
* `club_id`: `UUID` (Foreign Key $\rightarrow$ `clubs.id`)
* `student_id`: `UUID` (Foreign Key $\rightarrow$ `students.id`)
* `role`: `VARCHAR(20)` (`MEMBER`, `LEADER`)
* `joined_at`: `TIMESTAMP`

#### 7. Nhóm Quản lý Đơn từ (Applications)

##### `applications` (Đơn xin nghỉ học, đơn ra ngoài...)

* `id`: `UUID` (Primary Key)
* `student_id`: `UUID` (Foreign Key $\rightarrow$ `students.id`)
* `parent_id`: `UUID` (Foreign Key $\rightarrow$ `users.id` - Người làm đơn)
* `application_type`: `VARCHAR(50)` (`SICK_LEAVE`, `EARLY_LEAVE`, `OTHER`)
* `reason`: `TEXT`
* `from_date`, `to_date`: `DATE`
* `status`: `VARCHAR(20)` (`PENDING`, `APPROVED`, `REJECTED`)
* `submitted_at`: `TIMESTAMP`

---

### II. Danh sách các REST Endpoints hiện tại

> **Yêu cầu bảo mật:** Header bắt buộc phải có `Authorization: Bearer <JWT_TOKEN>` (Ngoại trừ nhóm `/auth`).

* **🔐 1. Nhóm Auth:**
* `POST /api/v1/auth/login`: Xác thực tài khoản $\rightarrow$ Trả về JWT Token + Danh sách các con liên kết.
* `POST /api/v1/auth/reset-password`: Yêu cầu cấp lại mật khẩu.


* **🏠 2. Nhóm Home:**
* `GET /api/v1/students/{studentId}/today`: Lấy trạng thái điểm danh tổng quan trong ngày của học sinh để hiển thị lên Banner Trang chủ.


* **📅 3. Nhóm Lịch học & Điểm danh:**
* `GET /api/v1/students/{studentId}/timetable?date=yyyy-MM-dd`: Lấy thời khóa biểu kèm trạng thái điểm danh từng tiết học trong ngày chỉ định.


* **🏆 4. Nhóm Học tập:**
* `GET /api/v1/students/{studentId}/grades?semester=...&schoolYear=...`: Lấy bảng điểm chi tiết và lời phê môn học.


* **📣 5. Nhóm Sự kiện:**
* `GET /api/v1/events`: Danh sách các sự kiện sắp diễn ra.
* `GET /api/v1/events/{eventId}`: Chi tiết sự kiện và các `event_property`.
* `POST /api/v1/events/{eventId}/register`: Phụ huynh đăng ký tham gia sự kiện.


* **👥 6. Nhóm Câu lạc bộ:**
* `GET /api/v1/students/{studentId}/clubs`: Các câu lạc bộ học sinh hiện tại đang tham gia.
* `GET /api/v1/clubs`: Danh sách toàn bộ các câu lạc bộ của trường.
* `GET /api/v1/clubs/{clubId}`: Xem chi tiết thông tin, lịch sinh hoạt của câu lạc bộ.


* **📝 7. Nhóm Đơn từ:**
* `GET /api/v1/students/{studentId}/applications`: Lịch sử gửi đơn và trạng thái phê duyệt.
* `POST /api/v1/applications`: Tạo đơn xin phép mới.


* **👤 8. Nhóm Hồ sơ:**
* `GET /api/v1/users/profile`: Đọc dữ liệu tài khoản phụ huynh.
* `PUT /api/v1/users/profile/password`: Đổi mật khẩu.



---

## MỤC B: CÁC TÍNH NĂNG MỞ RỘNG (NICE-TO-HAVE - THỰC HIỆN KHI CÒN THỜI GIAN)

Danh mục các tính năng tăng cường trải nghiệm người dùng, tự động hóa thông báo thời gian thực và quản lý truyền thông nội bộ toàn trường.

### I. Cấu trúc các bảng bổ sung

#### 1. Hệ thống Đẩy thông báo thời gian thực (Push Notification)

##### `user_device_tokens` (Lưu thông tin định danh thiết bị để tích hợp Firebase Cloud Messaging)

* `id`: `UUID` (Primary Key)
* `user_id`: `UUID` (Foreign Key $\rightarrow$ `users.id`)
* `device_token`: `TEXT` (Mã Token định danh duy nhất do Firebase SDK cấp trên thiết bị di động)
* `device_type`: `VARCHAR(10)` (`ANDROID`, `IOS`)
* `last_active`: `TIMESTAMP` (Thời gian tương tác cuối để lọc token rác)

#### 2. Hệ thống Tin tức & Truyền thông nội bộ (School News)

##### `school_news` (Quản lý các bài viết tin tức hiển thị tại Trang chủ thay thế cho dữ liệu hardcode)

* `id`: `UUID` (Primary Key)
* `title`: `VARCHAR(255)` (Tiêu đề tin tức, ví dụ: "Thông báo điều chỉnh lịch học học kỳ hè")
* `summary`: `VARCHAR(500)` (Đoạn trích dẫn ngắn hiển thị ngoài danh sách tổng quan)
* `content`: `TEXT` (Nội dung chi tiết bài viết, lưu trữ định dạng Rich Text hoặc Markdown)
* `thumbnail_url`: `VARCHAR(255)` (Đường dẫn ảnh đại diện bài viết)
* `created_at`: `TIMESTAMP`

---

### II. Các REST Endpoints bổ sung tương ứng

#### 📱 1. Nhóm Đăng ký Thiết bị & Đồng bộ Thông báo

* `POST /api/v1/users/register-device`
* **Mục đích:** Gửi lên `device_token` từ thiết bị di động ngay khi phụ huynh bấm nút "Cho phép nhận thông báo" trên giao diện để đồng bộ xuống cơ sở dữ liệu.
* **Payload:** `{ "device_token": "fcm_token_string_here", "device_type": "ANDROID" }`


* `DELETE /api/v1/users/unregister-device/{deviceToken}`
* **Mục đích:** Xóa token thiết bị khỏi hệ thống khi người dùng đăng xuất tài khoản, tránh việc đẩy thông báo nhầm thiết bị.



#### 📰 2. Nhóm Tương tác Tin tức Hệ thống

* `GET /api/v1/school-news/latest`
* **Mục đích:** Lấy danh sách 3 - 5 bài tin tức mới nhất phục vụ render động lên widget Tin tức ở Trang chủ di động.


* `GET /api/v1/school-news?page=0&size=10`
* **Mục đích:** Lấy toàn bộ danh sách tin tức hỗ trợ **Phân trang (Pagination)** và sắp xếp theo thời gian mới nhất khi phụ huynh bấm vào màn hình chuyên biệt "Tất cả tin tức" (Xử lý cuộn vô hạn phía Mobile).


* `GET /api/v1/school-news/{newsId}`
* **Mục đích:** Xem nội dung chi tiết dạng Markdown của một bài viết tin tức cụ thể.
