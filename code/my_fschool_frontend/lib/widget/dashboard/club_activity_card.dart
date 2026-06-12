import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class ClubActivityCard extends StatelessWidget {
  const ClubActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push("/club");
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Vòng tròn chứa Icon nhóm hoạt động
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.blueFPT.withValues(alpha: 0.1),
              child: const Icon(
                Icons.groups_rounded,
                color: AppColors.blueFPT,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "Hoạt động câu lạc bộ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: 'Asap',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
