import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class CalendarHeaderBar extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate;
  final List<DateTime> Function(DateTime) getDaysInWeek;

  const CalendarHeaderBar({
    super.key,
    required this.selectedDate,
    required this.getDaysInWeek,
  });

  @override
  Widget build(BuildContext context) {
    final List<DateTime> weekDays = getDaysInWeek(selectedDate.value);
    final List<String> dayLabels = [
      'Hai',
      'Ba',
      'Tư',
      'Năm',
      'Sáu',
      'Bảy',
      'CN',
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(weekDays.length, (index) {
          final DateTime dayDate = weekDays[index];
          final isSelected = DateUtils.isSameDay(dayDate, selectedDate.value);
          final isToday = DateUtils.isSameDay(dayDate, DateTime.now());

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                selectedDate.value = dayDate;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orangeFPT : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppColors.orangeFPT.withValues(alpha: 0.5),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayLabels[index],
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : (isToday ? AppColors.orangeFPT : Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('d/M').format(dayDate),
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
