import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class AppDateRange extends StatelessWidget {
  final String label;
  final String placeholder;
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange?> onRangeSelected;
  final String? Function(DateTimeRange?)? validator;

  const AppDateRange({
    super.key,
    required this.label,
    this.placeholder = 'Bấm để chọn khoảng thời gian...',
    required this.selectedRange,
    required this.onRangeSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Chạy validator thủ công để lấy chuỗi báo lỗi nếu có
    final errorText = validator?.call(selectedRange);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLabel,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Asap',
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final pickedRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 7)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              initialDateRange: selectedRange,
              saveText: 'Chọn',
              helpText: 'Chọn khoảng thời gian',
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    useMaterial3: true,
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.orangeFPT,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: AppColors.textPrimary,
                    ),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: AppColors.orangeFPT,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedRange != null) {
              onRangeSelected(pickedRange);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              // Đổi màu gạch chân sang màu đỏ nếu có lỗi validate
              border: Border(
                bottom: BorderSide(
                  color: errorText != null
                      ? AppColors.gradeBad
                      : AppColors.inputBorder,
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedRange == null
                      ? placeholder
                      : '${dateFormat.format(selectedRange!.start)}  ➔  ${dateFormat.format(selectedRange!.end)}',
                  style: TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 16,
                    color: selectedRange == null
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontWeight: selectedRange == null
                        ? FontWeight.normal
                        : FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        // Hiển thị text lỗi validate chuẩn chỉnh phía dưới thanh gạch chân
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: AppColors.gradeBad, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
