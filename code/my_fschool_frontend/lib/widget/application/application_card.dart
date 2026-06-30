import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/model/response/application_response.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationResponse application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    // Phân loại màu sắc theo trạng thái đơn từ
    Color statusBgColor = const Color(0xFFFFB74D); // Mặc định Chờ duyệt (Vàng)
    Color statusTextColor = Colors.white;
    String statusLabel = 'Chờ duyệt';

    if (application.status == 'APPROVED') {
      statusBgColor = const Color(0xFF4CAF50); // Đã chấp thuận (Xanh lá)
      statusLabel = 'Đã chấp thuận';
    } else if (application.status == 'REJECTED') {
      statusBgColor = const Color(0xFFEF5350); // Từ chối (Đỏ)
      statusLabel = 'Từ chối';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề đơn & Badge Trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    application.title,
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🎯 THAY ĐỔI: Chuyển toàn bộ thông tin kiểm toán thành cấu trúc danh sách dọc (Mỗi thông tin 1 hàng)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  'Ngày gửi: ${application.sentDate}',
                ),

                // 🎯 Nếu đơn có cấu hình ngày nghỉ (from_date & to_date) thì hiển thị ra hàng riêng
                if (application.fromDate != null &&
                    application.toDate != null) ...[
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    Icons.date_range_outlined,
                    application.fromDate == application.toDate
                        ? 'Ngày xin nghỉ: ${application.fromDate}'
                        : 'Nghỉ từ: ${application.fromDate} -> Đến: ${application.toDate}',
                  ),
                ],

                if (application.processedDate != null) ...[
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    'Thời gian xử lý: ${application.processedDate}',
                  ),
                ],

                if (application.handlerName != null) ...[
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    Icons.assignment_ind_outlined,
                    'Người duyệt: ${application.handlerName}',
                    isBold: true,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFECEFF1), height: 1),
            const SizedBox(height: 14),

            // Phần nội dung Yêu cầu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 13,
                    color: Color(0xFF37474F),
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Yêu cầu: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: application.requestContent),
                  ],
                ),
              ),
            ),

            // Phần nội dung Phản hồi từ nhà trường (Nếu có)
            if (application.responseContent != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 13,
                      color: Color(0xFF2E7D32),
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Phản hồi: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: application.responseContent),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 🧱 Hàm helper dựng hàng thông tin kèm icon chuẩn phẳng, sạch sẽ
  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Asap',
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: isBold ? Colors.grey[800] : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
