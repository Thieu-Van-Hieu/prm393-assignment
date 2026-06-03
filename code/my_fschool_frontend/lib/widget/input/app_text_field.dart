import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class AppTextField extends HookWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng hook để quản lý trạng thái ẩn/hiện mật khẩu độc lập
    final obscureTextNotifier = useState(isPassword);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label chữ màu Cam FPT đặc trưng theo mockup
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
        TextFormField(
          controller: controller,
          obscureText: obscureTextNotifier.value,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontFamily: 'Asap',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            // Đường gạch dưới chân (Underline) theo mockup
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.inputBorder, width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.orangeFPT, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gradeBad, width: 1.5),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.gradeBad, width: 2),
            ),
            // Nếu là trường password thì hiển thị icon con mắt
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureTextNotifier.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.iconEye,
                      size: 22,
                    ),
                    onPressed: () =>
                        obscureTextNotifier.value = !obscureTextNotifier.value,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
