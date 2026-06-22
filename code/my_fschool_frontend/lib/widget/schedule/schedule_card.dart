import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/enum/attendance_status.dart';
import 'package:my_fschool_frontend/model/response/schedule_response.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleResponse item;

  const ScheduleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isNotYet = item.attendanceStatus == AttendanceStatus.notYet;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNotYet
              ? AppColors.orangeFPT.withValues(alpha: 0.3)
              : Colors.transparent,
          width: isNotYet ? 1.5 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isNotYet
                        ? AppColors.orangeFPT
                        : AppColors.orangeFPT.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Tiết ${item.slotNumber}',
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isNotYet ? Colors.white : AppColors.orangeFPT,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item.formattedTimeRange,
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.attendanceStatus.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.attendanceStatus.label,
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: item.attendanceStatus.textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.subjectName,
              style: const TextStyle(
                fontFamily: 'Asap',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: 'Giảng viên: '),
                      TextSpan(
                        text: item.teacherName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: 'Phòng: '),
                      TextSpan(
                        text: item.roomName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
