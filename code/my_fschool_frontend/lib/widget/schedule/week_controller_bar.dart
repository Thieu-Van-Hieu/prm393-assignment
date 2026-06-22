import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class WeekControllerBar extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate;
  final List<DateTime> Function(DateTime) getDaysInWeek;

  const WeekControllerBar({
    super.key,
    required this.selectedDate,
    required this.getDaysInWeek,
  });

  @override
  Widget build(BuildContext context) {
    final List<DateTime> weekDays = getDaysInWeek(selectedDate.value);
    final DateTime startOfWeek = weekDays.first;
    final DateTime endOfWeek = weekDays.last;

    String weekRangeLabel;
    if (startOfWeek.month == endOfWeek.month) {
      weekRangeLabel = 'Tháng ${DateFormat('MM, yyyy').format(startOfWeek)}';
    } else {
      weekRangeLabel =
          'T${startOfWeek.month}/${startOfWeek.year} - T${endOfWeek.month}/${endOfWeek.year}';
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.orangeFPT,
              size: 28,
            ),
            onPressed: () {
              selectedDate.value = selectedDate.value.subtract(
                const Duration(days: 7),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              selectedDate.value = DateTime.now();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.orangeFPT,
                ),
                const SizedBox(width: 8),
                Text(
                  weekRangeLabel,
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.orangeFPT,
              size: 28,
            ),
            onPressed: () {
              selectedDate.value = selectedDate.value.add(
                const Duration(days: 7),
              );
            },
          ),
        ],
      ),
    );
  }
}
