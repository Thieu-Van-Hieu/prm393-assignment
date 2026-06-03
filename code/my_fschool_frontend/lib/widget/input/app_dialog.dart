import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content; // Nội dung tự do (ví dụ: Ô nhập SĐT)
  final List<Widget>?
  actions; // Các nút chức năng tự do (Free Style) bên phải nút Hủy

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  // Hàm static để gọi hiển thị Dialog nhanh ở bất cứ đâu
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      // Bắt buộc phải bấm Hủy hoặc Xử lý chứ không bấm ra ngoài để tắt
      builder: (context) =>
          AppDialog(title: title, content: content, actions: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Bo góc chuẩn mịn màng
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Tự động co giãn chiều cao theo nội dung
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TIÊU ĐỀ DIALOG
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // 2. NỘI DUNG TỰ DO CHÈN VÀO (Ô NHẬP SĐT...)
            Flexible(child: SingleChildScrollView(child: content)),
            const SizedBox(height: 16),

            // 3. THANH NÚT BẤM (DƯỚI CÙNG)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Nút Hủy mặc định: Secondary + Small + Custom width để không bị full-width
                AppButton(
                  text: 'Hủy',
                  type: AppButtonType.secondary,
                  size: AppButtonSize.small,
                  width: 80,
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(false), // Bấm là đóng dialog trả về false
                ),

                // Nếu có truyền các nút free style khác thì hiển thị ở đây
                if (actions != null) ...[
                  const SizedBox(width: 12),
                  ...actions!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
