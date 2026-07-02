import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_date_range.dart';
import 'package:my_fschool_frontend/widget/input/app_text_area.dart';

class CreateApplicationSheetContent extends HookWidget {
  final Function({
    required String typeCode,
    required String reason,
    String? fromDate,
    String? toDate,
  })
  onSubmit;

  const CreateApplicationSheetContent({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final applicationOptions = [
      {'label': 'Đơn xin nghỉ học', 'code': 'SICK_LEAVE'},
      {'label': 'Đơn xin miễn giảm hoạt động', 'code': 'ACTIVITY_EXEMPTION'},
      {'label': 'Đơn khác', 'code': 'OTHER'},
    ];

    final selectedTypeCode = useState<String>('SICK_LEAVE');
    final reasonController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final dateRange = useState<DateTimeRange?>(null);

    final apiDateFormat = DateFormat('yyyy-MM-dd');

    // Biến trigger để ép hiển thị lỗi của trường Date khi bấm nút Submit
    final validateDateTrigger = useState<bool>(false);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Dropdown Loại đơn
          const Text(
            'Loại đơn',
            style: TextStyle(
              color: AppColors.textLabel,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Asap',
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: selectedTypeCode.value,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
            dropdownColor: Colors.white,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.inputBorder,
                  width: 1.5,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.orangeFPT, width: 2),
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Asap',
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            items: applicationOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option['code'],
                child: Text(option['label']!),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedTypeCode.value = newValue;
              }
            },
          ),
          const SizedBox(height: 24),

          // 2. Ô chọn thời gian (Chỉ hiển thị khi chọn SICK_LEAVE) - Đã đóng gói gọn gàng
          if (selectedTypeCode.value == 'SICK_LEAVE') ...[
            AppDateRange(
              label: 'Thời gian xin nghỉ',
              placeholder: 'Bấm để chọn ngày nghỉ...',
              selectedRange: dateRange.value,
              onRangeSelected: (range) {
                dateRange.value = range;
              },
              validator: (range) {
                // Chỉ hiển thị lỗi khi form đã được submit qua nút bấm
                if (validateDateTrigger.value && range == null) {
                  return 'Vui lòng chọn thời gian nghỉ học';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
          ],

          // 3. Ô nhập Lý do
          AppTextArea(
            label: 'Lý do',
            hintText:
                'Vui lòng nhập lý do chi tiết để giáo viên chủ nhiệm phê duyệt',
            controller: reasonController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng không để trống lý do viết đơn';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // 4. Nút Gửi đơn
          AppButton(
            text: 'Gửi đơn từ',
            type: AppButtonType.primary,
            size: AppButtonSize.big,
            onPressed: () {
              // Bật trigger kiểm tra ngày
              validateDateTrigger.value = true;

              final isFormValid = formKey.currentState?.validate() ?? false;
              final isDateValid =
                  selectedTypeCode.value != 'SICK_LEAVE' ||
                  dateRange.value != null;

              if (isFormValid && isDateValid) {
                onSubmit(
                  typeCode: selectedTypeCode.value,
                  reason: reasonController.text.trim(),
                  fromDate: dateRange.value != null
                      ? apiDateFormat.format(dateRange.value!.start)
                      : null,
                  toDate: dateRange.value != null
                      ? apiDateFormat.format(dateRange.value!.end)
                      : null,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
