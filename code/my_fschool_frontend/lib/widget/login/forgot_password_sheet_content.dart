import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_text_field.dart';

class ForgotPasswordSheetContent extends StatelessWidget {
  final TextEditingController forgotPhoneController;
  final VoidCallback handleForgotPassword;

  const ForgotPasswordSheetContent({
    super.key,
    required this.forgotPhoneController,
    required this.handleForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mật khẩu mới sẽ được gửi qua tới số điện thoại này.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontFamily: 'Asap',
            ),
          ),
          const SizedBox(height: 24),

          // Ô nhập liệu Số điện thoại
          AppTextField(
            label: 'Số điện thoại phụ huynh',
            hintText: 'Nhập số điện thoại để nhận mã',
            controller: forgotPhoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_android_outlined,
              color: AppColors.textSecondary,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng không để trống số điện thoại';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Hành động Gửi OTP (Full width cho đúng chuẩn UI mobile)
          AppButton(
            text: 'Gửi OTP',
            type: AppButtonType.primary,
            size: AppButtonSize.big,
            onPressed: handleForgotPassword,
          ),
        ],
      ),
    );
  }
}
