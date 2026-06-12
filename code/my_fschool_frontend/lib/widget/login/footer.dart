import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Phiên bản 1.0.0',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontFamily: 'Asap',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2026 FPT Schools. All rights reserved.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
            fontFamily: 'Asap',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Developed by Mr.NoBody',
          style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
            fontFamily: 'Asap',
          ),
        ),
      ],
    );
  }
}
