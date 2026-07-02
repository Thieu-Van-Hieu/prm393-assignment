import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'club_response.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ClubResponse with ClubResponseMappable {
  final String id;
  final String clubName;
  final String? description;
  final String? base64Image;
  final String? schedules;

  // Các trường bổ sung từ bảng club_members (null nếu học sinh chưa tham gia)
  final String? role;

  ClubResponse({
    required this.id,
    required this.clubName,
    this.description,
    this.base64Image,
    this.schedules,
    this.role,
  });

  // 1. Kiểm tra trạng thái tham gia của học sinh
  bool get isJoined => role != null;

  // 2. Chuyển đổi dữ liệu ảnh đại diện từ chuỗi Base64
  Uint8List? get memoryImage {
    debugPrint('Base64 Image: $base64Image');
    if (base64Image == null ||
        base64Image!.trim().isEmpty ||
        base64Image!.contains('holder')) {
      // 🎯 Sửa '_holder' thành 'holder' để khớp với SQL script của bạn
      return null;
    }
    try {
      return base64Decode(base64Image!);
    } catch (_) {
      return null;
    }
  }

  // 3. 🎯 Fallback Icon cho CLB map chuẩn 100% theo data thực tế của trường học
  IconData get fallbackIcon {
    final lowerName = clubName.toLowerCase();

    // Nhóm Bóng đá / Thể thao
    if (lowerName.contains('bóng đá') ||
        lowerName.contains('thao') ||
        lowerName.contains('bóng')) {
      return Icons.sports_soccer_rounded;
    }
    // Nhóm Công nghệ / Kỹ thuật / Chế tạo (Khớp CLB Robotics & IoT)
    if (lowerName.contains('robot') ||
        lowerName.contains('iot') ||
        lowerName.contains('tech')) {
      return Icons
          .precision_manufacturing_rounded; // Icon cánh tay robot cực chất
    }
    // Nhóm Nghệ thuật / Hội họa (Khớp CLB Mỹ Thuật Sáng Tạo)
    if (lowerName.contains('mỹ thuật') ||
        lowerName.contains('vẽ') ||
        lowerName.contains('họa') ||
        lowerName.contains('art')) {
      return Icons.brush_rounded; // Icon cây cọ vẽ nghệ thuật
    }
    // Nhóm Âm nhạc / Nhảy múa
    if (lowerName.contains('nhạc') ||
        lowerName.contains('music') ||
        lowerName.contains('hát')) {
      return Icons.music_note_rounded;
    }
    // Nhóm Truyền thông / Phim ảnh
    if (lowerName.contains('ảnh') ||
        lowerName.contains('media') ||
        lowerName.contains('phim')) {
      return Icons.camera_alt_rounded;
    }

    return Icons.groups_rounded; // Icon mặc định hội nhóm
  }

  // 4. 🎯 Map bảng màu UI xịn theo phân loại CLB (Phục vụ hiển thị container hoặc viền cứng)
  Color get dynamicPrimaryColor {
    final lowerName = clubName.toLowerCase();

    if (lowerName.contains('bóng đá') || lowerName.contains('bóng')) {
      return const Color(0xFF2E7D32); // Xanh lá sân cỏ năng động (Green)
    }
    if (lowerName.contains('robot') || lowerName.contains('iot')) {
      return const Color(0xFF00ACC1); // Xanh cyan công nghệ hiện đại (Cyan)
    }
    if (lowerName.contains('mỹ thuật') || lowerName.contains('art')) {
      return const Color(
        0xFFD81B60,
      ); // Hồng cánh sen sáng tạo đầy nghệ thuật (Pink)
    }
    if (lowerName.contains('nhạc') || lowerName.contains('music')) {
      return const Color(0xFF673AB7); // Tím bay bổng âm nhạc (Deep Purple)
    }

    // Thuật toán dự phòng băm dải màu tươi sáng nếu có CLB mới phát sinh
    int hash = 0;
    for (int i = 0; i < clubName.length; i++) {
      hash = clubName.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return HSLColor.fromColor(
      Color((hash & 0x00FFFFFF) | 0xFF000000),
    ).withLightness(0.45).withSaturation(0.65).toColor();
  }

  // 5. Tạo màu nhạt (Pastel) cho Icon Background ở danh sách CLB chưa tham gia
  Color get dynamicPastelColor {
    return Color.alphaBlend(
      dynamicPrimaryColor.withValues(alpha: 0.12),
      Colors.white,
    );
  }

  static ClubResponse fromJson(String json) {
    return ClubResponseMapper.fromJson(json);
  }

  static ClubResponse fromMap(Map<String, dynamic> map) {
    return ClubResponseMapper.fromMap(map);
  }
}
