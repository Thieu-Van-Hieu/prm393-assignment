import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;

  const AppBottomSheet({super.key, required this.title, required this.content});

  // Hàm static để gọi hiển thị nhanh từ bất kỳ screen nào
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      // Cho phép nội dung đẩy lên khi bàn phím ảo hiện diện
      backgroundColor: Colors.transparent,
      // Để lộ phần bo góc mượt mà bên dưới
      barrierColor: Colors.black.withValues(alpha: 0.4),
      // Màu nền xám mờ xung quanh, bấm vào tự tắt
      builder: (context) => AppBottomSheet(title: title, content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ép nội dung co giãn theo bàn phím (tránh bị che khuất ô Input)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 20,
        right: 20,
        bottom: bottomInset + 24, // Cộng thêm khoảng trống bàn phím ảo
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), // Bo góc mịn màng phía trên
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Tự co giãn theo ruột dữ liệu bên trong
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. THANH GỜ VUỐT (DRAG HANDLE) CHUẨN MODERN UI
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 2. THANH TIÊU ĐỀ: Nút X bên trái - Chữ ở giữa
          Row(
            children: [
              // Nút X ở góc trái theo mockup của phen
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 12),
              // Tiêu đề căn giữa
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Asap',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. RUỘT NỘI DUNG TỰ DO CHÈN VÀO (Thông tin cá nhân / Đổi mật khẩu)
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
