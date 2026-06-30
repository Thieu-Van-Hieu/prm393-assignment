import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class AppTextArea extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;

  const AppTextArea({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.maxLines = 4,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontFamily: 'Asap',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            // Đồng bộ thiết kế gạch chân (Underline) giống AppTextField
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
          ),
        ),
      ],
    );
  }
}
