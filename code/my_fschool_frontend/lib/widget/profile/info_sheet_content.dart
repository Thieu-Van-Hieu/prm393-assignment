import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/response/user_response.dart';

class InfoSheetContent extends StatelessWidget {
  final UserResponse profile;

  const InfoSheetContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Họ và tên', profile.fullName),
        _buildInfoRow('Số điện thoại liên hệ', profile.phoneNumber),
        _buildInfoRow('Email', profile.email),
        _buildInfoRow(
          'Vai trò',
          profile.roleName == "PARENT" ? "Phụ huynh" : profile.roleName,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Asap',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Asap',
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Vạch kẻ mờ phân tách hàng
        ],
      ),
    );
  }
}
