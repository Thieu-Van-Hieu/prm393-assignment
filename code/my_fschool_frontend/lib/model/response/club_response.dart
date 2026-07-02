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
        base64Image!.contains('_holder')) {
      return null;
    }
    try {
      return base64Decode(base64Image!);
    } catch (_) {
      return null;
    }
  }

  // 3. Fallback Icon cho CLB nếu không có ảnh Base64 hoặc ảnh lỗi
  IconData get fallbackIcon {
    final lowerName = clubName.toLowerCase();
    if (lowerName.contains('nhạc') || lowerName.contains('music')) {
      return Icons.music_note_rounded;
    }
    if (lowerName.contains('ảnh') ||
        lowerName.contains('media') ||
        lowerName.contains('phim')) {
      return Icons.camera_alt_rounded;
    }
    if (lowerName.contains('thao') || lowerName.contains('bóng')) {
      return Icons.sports_soccer_rounded;
    }
    return Icons.groups_rounded; // Icon mặc định hội nhóm
  }

  // 4. Giải thuật tạo màu chủ đạo (Primary) động từ tên CLB tránh hardcode màu card lớn
  Color get dynamicPrimaryColor {
    int hash = 0;
    for (int i = 0; i < clubName.length; i++) {
      hash = clubName.codeUnitAt(i) + ((hash << 5) - hash);
    }
    // Lấy tông màu đậm cho Container của CLB đã tham gia
    return Color((hash & 0x00FFFFFF) | 0xFF000000).withAlpha(230);
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
