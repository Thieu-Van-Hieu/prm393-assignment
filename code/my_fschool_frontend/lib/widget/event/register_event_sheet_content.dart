import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_text_area.dart';

class RegisterEventSheetContent extends HookWidget {
  final String eventTitle;
  final Function({required int memberCount, required String note}) onSubmit;

  const RegisterEventSheetContent({
    super.key,
    required this.eventTitle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    // Controller cho số lượng thành viên đi cùng (mặc định là 1) và ghi chú
    final memberController = useTextEditingController(text: '1');
    final noteController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Số lượng thành viên đi cùng (Thiết kế gạch chân giống AppTextField)
          const Text(
            'Số lượng thành viên đi cùng',
            style: TextStyle(
              color: AppColors.orangeFPT, // Tông cam theo mockup của phen
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Asap',
            ),
          ),
          TextFormField(
            controller: memberController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontFamily: 'Asap',
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
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
            validator: (value) {
              if (value == null ||
                  int.tryParse(value) == null ||
                  int.parse(value) < 0) {
                return 'Vui lòng nhập số lượng hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // 2. Ô nhập Ghi chú (Dùng lại AppTextAreaField nền trắng gạch chân)
          AppTextArea(
            label: 'Ghi chú',
            hintText:
                'Ví dụ: Đăng ký xe tuyến đưa đón của trường, chế độ ăn thuần chay...',
            controller: noteController,
          ),
          const SizedBox(height: 32),

          // 3. Nút Đăng ký màu Cam
          AppButton(
            text: 'Đăng ký',
            type: AppButtonType.primary,
            size: AppButtonSize.big,
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                onSubmit(
                  memberCount: int.parse(memberController.text.trim()),
                  note: noteController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
