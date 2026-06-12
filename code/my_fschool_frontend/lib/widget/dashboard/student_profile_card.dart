import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

class StudentProfileCard extends StatelessWidget {
  final String studentName;
  final String className;
  final String? avatarUrl;
  final bool showSwitchButton;
  final VoidCallback onSwitchPressed;

  const StudentProfileCard({
    super.key,
    required this.studentName,
    required this.className,
    this.avatarUrl,
    required this.showSwitchButton,
    required this.onSwitchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // 🎯 Bọc InkWell để biến toàn bộ Card thành nút bấm
      child: InkWell(
        onTap: onSwitchPressed,
        // Cứ chạm vào bất kỳ đâu trên Card là kích hoạt đổi bé
        borderRadius: BorderRadius.circular(24),
        // Bo góc hiệu ứng ripple khít với Container cha
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 🛡️ Avatar học sinh
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.homeBannerBg.withValues(alpha: 0.1),
                ),
                child: ClipOval(
                  child: hasValidUrl
                      ? Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          headers: const {
                            'User-Agent':
                                'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36',
                          },
                          frameBuilder:
                              (
                                context,
                                frameChild,
                                frame,
                                wasSynchronouslyLoaded,
                              ) {
                                if (wasSynchronouslyLoaded) return frameChild;
                                return frame != null
                                    ? AnimatedOpacity(
                                        opacity: 1.0,
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        child: frameChild,
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppColors.homeBannerBg,
                                      );
                              },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 32,
                              color: AppColors.homeBannerBg,
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          size: 32,
                          color: AppColors.homeBannerBg,
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Thông tin Tên và Lớp học
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Asap',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      className,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontFamily: 'Asap',
                      ),
                    ),
                  ],
                ),
              ),

              if (showSwitchButton)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.orangeFPT.withValues(alpha: 0.1),
                    // Nền cam nhạt nhẹ nhàng
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sync,
                    // Hoặc đổi thành Icons.chevron_right tùy gu thẩm mỹ của phen
                    size: 20,
                    color: AppColors.orangeFPT,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
