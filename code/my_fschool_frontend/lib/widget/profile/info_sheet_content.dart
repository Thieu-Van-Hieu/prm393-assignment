import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/response/user_response.dart';

class InfoSheetContent extends StatelessWidget {
  final UserResponse profile;
  final int workspaceIndex;

  const InfoSheetContent({
    super.key,
    required this.profile,
    required this.workspaceIndex,
  });

  @override
  Widget build(BuildContext context) {
    final workspace = profile.userWorkspaceResponses[workspaceIndex];
    String roleName = "Chưa xác định";
    switch (workspace.roleName.trim()) {
      case "PARENT":
        roleName = "Phụ huynh";
        break;
      case "STUDENT":
        roleName = "Học sinh";
        break;
      default:
        roleName = "Chưa xác định";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Họ và tên', profile.fullName),
        _buildInfoRow('Số điện thoại liên hệ', profile.phoneNumber),
        _buildInfoRow('Email', profile.email),
        _buildInfoRow('Vai trò', roleName),
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
