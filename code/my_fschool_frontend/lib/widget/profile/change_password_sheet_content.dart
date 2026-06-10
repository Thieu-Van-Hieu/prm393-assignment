import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_text_field.dart';

class ChangePasswordSheetContent extends HookWidget {
  final Function(String oldPass, String newPass) onSubmitted;
  final bool isLoading;

  const ChangePasswordSheetContent({
    super.key,
    required this.onSubmitted,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final oldPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Mật khẩu hiện tại',
            hintText: '••••••••',
            controller: oldPasswordController,
            isPassword: true,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Vui lòng nhập mật khẩu hiện tại'
                : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Mật khẩu mới',
            hintText: 'Tối thiểu 6 ký tự',
            controller: newPasswordController,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu mới';
              }
              if (value.length < 6) {
                return 'Mật khẩu mới phải tối thiểu từ 6 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          AppButton(
            text: 'Cập nhật',
            type: AppButtonType.primary,
            size: AppButtonSize.big,
            isLoading: isLoading,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onSubmitted(
                  oldPasswordController.text,
                  newPasswordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
