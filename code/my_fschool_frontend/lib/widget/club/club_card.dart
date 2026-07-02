import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/model/response/club_response.dart';

class ClubCard extends StatelessWidget {
  final ClubResponse club;
  final bool isJoined;

  const ClubCard({super.key, required this.club, required this.isJoined});

  @override
  Widget build(BuildContext context) {
    final imageBytes = club.memoryImage;

    // Thành phần bọc ảnh dùng chung cho cả 2 kiểu giao diện
    final Widget imageWidget = Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: club.dynamicPastelColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageBytes != null
            ? Image.memory(imageBytes, fit: BoxFit.cover)
            : Icon(club.fallbackIcon, color: const Color(0xFFFF5722), size: 26),
      ),
    );

    // 🌟 KIỂU 1: Giao diện dành cho CLB ĐÃ tham gia (Card to, nền đậm)
    if (isJoined) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: club.dynamicPrimaryColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: club.dynamicPrimaryColor.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget, // Hiển thị ảnh CLB ở đây
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TÊN CÂU LẠC BỘ',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          fontSize: 11,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        club.clubName,
                        style: const TextStyle(
                          fontFamily: 'Asap',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(width: double.infinity, height: 1, color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chức vụ:',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Lịch sinh hoạt:',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        club.role ?? 'Thành viên',
                        style: const TextStyle(
                          fontFamily: 'Asap',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        club.schedules ?? 'Chưa cập nhật',
                        style: const TextStyle(
                          fontFamily: 'Asap',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 🌟 KIỂU 2: Giao diện dành cho CLB CHƯA tham gia (Card nhỏ, nền trắng, viền xanh)
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EDF5), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget, // Hiển thị ảnh CLB ở đây
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.clubName,
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F4C5C),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                if (club.description != null)
                  Text(
                    club.description!,
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 11,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
