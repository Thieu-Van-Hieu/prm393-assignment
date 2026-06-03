package prm393.se1911.assignment.myfschoolbackend.util;

import org.springframework.data.jpa.domain.Specification;

/**
 * Lớp tiện ích cung cấp các phương thức khởi tạo an toàn cho đối tượng {@link Specification} trong Spring Data JPA.
 *
 * <p>Lớp này giúp đơn giản hóa quá trình xây dựng các câu lệnh truy vấn động bằng cách tự động
 * kiểm tra các giá trị điều kiện (đầu vào). Nếu giá trị đầu vào không hợp lệ (null hoặc rỗng),
 * phương thức sẽ trả về một mệnh đề luôn đúng (Conjunction - tương đương điều kiện 1=1 trong SQL),
 * từ đó ngăn chặn việc sinh lỗi cấu trúc câu lệnh và không làm ảnh hưởng đến các logic {@code .and()} hoặc {@code .or()} tiếp theo.</p>
 *
 * <p>Giải pháp này giúp loại bỏ hoàn toàn việc lặp lại các khối lệnh kiểm tra {@code if (value != null)}
 * thủ công tại tầng Service hoặc Repository, giúp mã nguồn sạch và dễ bảo trì hơn.</p>
 *
 * @author Thiều Văn Hiếu
 * @version 1.0.0
 * @since 2026-06-01
 */
public class SafeSpecification {

    /**
     * Khởi tạo một đối tượng {@link Specification} an toàn dựa trên việc kiểm tra tính nguyên vẹn của giá trị đối tượng đầu vào.
     *
     * <p>Cơ chế hoạt động: Nếu đối tượng kiểm tra {@code value} có giá trị {@code null}, phương thức sẽ sinh ra
     * một cấu trúc đặc tả rỗng chuẩn JPA {@code cb.conjunction()}. Khi Spring Data dịch sang SQL, mệnh đề này
     * tự động được bỏ qua hoặc tối ưu hóa, đảm bảo tính toàn vẹn cho toàn bộ chuỗi liên kết điều kiện.</p>
     *
     * @param <T>   Kiểu dữ liệu của thực thể (Entity) được áp dụng truy vấn.
     * @param <V>   Kiểu dữ liệu của giá trị dùng để kiểm tra điều kiện lọc.
     * @param value Giá trị đầu vào cần kiểm tra tính hợp lệ trước khi áp dụng bộ lọc.
     * @param spec  Cấu trúc đặc tả truy vấn gốc chứa logic lọc dữ liệu mong muốn khi giá trị hợp lệ.
     * @return Đối tượng {@link Specification} gốc nếu giá trị không null; ngược lại trả về mệnh đề luôn đúng (Conjunction).
     */
    public static <T, V> Specification<T> of(V value, Specification<T> spec) {
        /*
         * Bước 1: Kiểm tra xem đối tượng điều kiện đầu vào có bị null hay không.
         */
        if (value == null) {
            /*
             * Bước 2: Trả về cb.conjunction() sinh ra điều kiện luôn đúng chuẩn JPA.
             * An toàn tuyệt đối khi gộp hoặc nối chuỗi các câu lệnh .and() hoặc .or() phía sau.
             */
            return (root, query, cb) -> cb.conjunction();
        }

        /*
         * Bước 3: Trả về cấu trúc truy vấn gốc nếu giá trị điều kiện hoàn toàn hợp lệ.
         */
        return spec;
    }

    /**
     * Biến thể Overload chuyên biệt dành riêng cho việc xử lý kiểu dữ liệu chuỗi ký tự (String).
     *
     * <p>Phương thức này nâng cao mức độ kiểm tra an toàn bằng cách không chỉ xác thực giá trị {@code null},
     * mà còn tự động loại bỏ khoảng trắng thừa hai đầu và kiểm tra xem chuỗi có bị rỗng (Blank/Empty) hay không.</p>
     *
     * @param <T>   Kiểu dữ liệu của thực thể (Entity) được áp dụng truy vấn.
     * @param value Chuỗi ký tự đầu vào cần kiểm tra (Ví dụ: từ khóa tìm kiếm, mã code, tên danh mục).
     * @param spec  Cấu trúc đặc tả truy vấn gốc chứa logic lọc dữ liệu mong muốn khi chuỗi hợp lệ.
     * @return Đối tượng {@link Specification} gốc nếu chuỗi có chứa ký tự thực tế; ngược lại trả về mệnh đề luôn đúng (Conjunction).
     */
    public static <T> Specification<T> ofString(String value, Specification<T> spec) {
        /*
         * Bước 1: Thực hiện kiểm tra đồng thời cả hai trường hợp chuỗi bị null hoặc chuỗi chỉ chứa khoảng trắng.
         */
        if (value == null || value.trim().isEmpty()) {
            /*
             * Bước 2: Trả về mệnh đề liên hợp luôn đúng nếu chuỗi không mang giá trị tìm kiếm thực tế.
             */
            return (root, query, cb) -> cb.conjunction();
        }

        /*
         * Bước 3: Tiếp tục áp dụng logic truy vấn gốc khi chuỗi đầu vào hợp lệ.
         */
        return spec;
    }
}

