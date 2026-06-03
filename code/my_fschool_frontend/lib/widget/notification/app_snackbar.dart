import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class AppSnackbar {
  // 1. Snackbar thông báo lỗi (Màu đỏ)
  static void showOpacityError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).clearSnackBars(); // Xóa các snackbar cũ đang hiện tránh bị xếp hàng đợi lâu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.gradeBad,
        // Sử dụng màu đỏ cảnh báo đã định nghĩa của bạn
        behavior: SnackBarBehavior.floating,
        // Hiển thị nổi bo góc hiện đại
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 2. Snackbar thông báo thành công (Màu xanh - Dùng khi gửi SMS thành công)
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.statusAttendedText,
        // Sử dụng màu xanh lá chuẩn của bạn
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
