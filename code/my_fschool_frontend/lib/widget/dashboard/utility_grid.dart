import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class UtilityGrid extends StatelessWidget {
  const UtilityGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Grid gồm 4 phím chức năng xếp thành 2 hàng x 2 cột
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.45,
      // Chỉnh tỷ lệ hộp chữ nhật lùn mập giống mockup
      children: [
        UtilityCard(
          title: 'Thời khóa biểu',
          iconAsset: '📅',
          onTap: () {
            context.go("/schedule");
          },
        ),
        UtilityCard(
          title: 'Bảng điểm',
          iconAsset: '🏅',
          onTap: () {
            context.go("/grades");
          },
        ),
        UtilityCard(
          title: 'Đơn từ',
          iconAsset: '📝',
          onTap: () {
            context.push("/application");
          },
        ),
        UtilityCard(
          title: 'Sự kiện',
          iconAsset: '📢',
          onTap: () {
            context.push("/event");
          },
        ),
      ],
    );
  }
}

class UtilityCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final VoidCallback onTap;

  const UtilityCard({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon hiển thị tạm bằng Emoji cỡ lớn, đổi thành hình vẽ sau nếu cần
            Text(iconAsset, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: 'Asap',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
