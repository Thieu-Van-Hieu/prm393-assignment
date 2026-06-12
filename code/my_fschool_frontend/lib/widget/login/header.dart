import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // LOGO FPT SCHOOL
        Image.asset(
          'assets/fpt_logo.png',
          height: 72,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.school,
              size: 48,
              color: AppColors.orangeFPT,
            );
          },
        ),
        const Text(
          'FPT Schools',
          style: TextStyle(
            color: AppColors.orangeFPT,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Asap',
          ),
        ),

        const SizedBox(height: 16),

        // CỤM CHỮ TIÊU ĐỀ ĐĂNG NHẬP
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Asap',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chào mừng đến với FPT Schools',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  fontFamily: 'Asap',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
