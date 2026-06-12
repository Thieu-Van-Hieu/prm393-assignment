import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class AttendanceStatusCard extends StatelessWidget {
  final String statusText;
  final String recordTime;
  final String? status; // 'ATTENDED', 'ABSENT', 'PENDING'

  const AttendanceStatusCard({
    super.key,
    required this.statusText,
    required this.recordTime,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Logic cấu hình Màu nền, Màu chữ và Icon động dựa trên status
    Color badgeBgColor = AppColors.statusPendingBg;
    Color badgeTextColor = AppColors.statusPendingText;
    IconData badgeIcon = Icons.hourglass_empty_rounded;

    if (status == 'ATTENDED') {
      badgeBgColor = AppColors.statusAttendedBg;
      badgeTextColor = AppColors.statusAttendedText;
      badgeIcon = Icons.check_box;
    } else if (status == 'ABSENT') {
      badgeBgColor = AppColors.statusAbsentBg;
      badgeTextColor = AppColors.statusAbsentText;
      badgeIcon = Icons.disabled_by_default_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.homeBannerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.assignment_ind_outlined,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Trạng thái điểm danh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Asap',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tag trạng thái tự động đổi màu sắc và icon sinh động
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, color: badgeTextColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Asap',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 🆕 Bẫy hiển thị thời gian thông minh dựa trên trạng thái thực tế
          Text(
            '🕒 Thời gian ghi nhận: $recordTime',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              fontFamily: 'Asap',
            ),
          ),
        ],
      ),
    );
  }
}
