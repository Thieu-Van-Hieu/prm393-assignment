import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/model/response/event_property_response.dart';

part 'event_response.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class EventResponse with EventResponseMappable {
  final String id;
  final String badge;
  final String title;
  final String? base64Image;
  final String? description;
  final List<EventPropertyResponse> eventProperties;

  EventResponse({
    required this.id,
    required this.badge,
    required this.title,
    this.base64Image,
    this.description,
    required this.eventProperties,
  });

  // 1. Kiểm tra xem sự kiện đã kết thúc dựa trên thuộc tính động chưa
  bool get isUpcoming {
    return !eventProperties.any((p) => p.propertyName.contains('Kết quả'));
  }

  // 2. Chuyển đổi chuỗi base64 sang định dạng byte (trả về null nếu chuỗi không hợp lệ)
  Uint8List? get memoryImage {
    if (base64Image == null ||
        base64Image!.trim().isEmpty ||
        base64Image!.contains('holder')) {
      // 🎯 Sửa chỗ này một chút để nhận diện chữ 'holder' trong SQL của bạn
      return null;
    }
    try {
      return base64Decode(base64Image!);
    } catch (_) {
      return null;
    }
  }

  // 3. 🎯 Map Icon thông minh khớp 100% với Data SQL mẫu của bạn
  IconData get fallbackIcon {
    final lowerBadge = badge.toLowerCase();
    final lowerTitle = title.toLowerCase();

    // Nhóm 1: Hội thao / Thể thao
    if (lowerBadge.contains('thao') || lowerTitle.contains('bóng đá')) {
      return Icons.sports_soccer_rounded;
    }
    // Nhóm 2: Hội thảo / Định hướng / Học thuật
    if (lowerBadge.contains('thảo') ||
        lowerTitle.contains('công nghệ') ||
        lowerTitle.contains('học')) {
      return Icons.co_present_rounded;
    }
    // Nhóm 3: Triển lãm / Mỹ thuật / Tranh ảnh
    if (lowerBadge.contains('lãm') ||
        lowerTitle.contains('mỹ thuật') ||
        lowerTitle.contains('sách')) {
      return Icons.palette_rounded;
    }
    // Nhóm 4: Hội rằm / Trung thu / Lễ hội truyền thống
    if (lowerBadge.contains('rằm') ||
        lowerTitle.contains('trăng rằm') ||
        lowerTitle.contains('trung thu')) {
      return Icons
          .brightness_3_rounded; // Icon trăng khuyết rất hợp với Trung Thu
    }
    // Nhóm 5: Các từ khóa trại hè, dã ngoại
    if (lowerBadge.contains('trại') || lowerBadge.contains('văn hóa')) {
      return Icons.gite_rounded;
    }

    return Icons.event_rounded; // Icon mặc định nhìn lịch lãm hơn star_rounded
  }

  // 4. 🎯 Thay vì băm màu ngẫu nhiên dễ ra màu tối/xấu, ta map dải màu tươi sáng theo Badge thực tế
  Color get dynamicPrimaryColor {
    final lowerBadge = badge.toLowerCase();

    if (lowerBadge.contains('thao')) {
      return const Color(0xFFE65100); // Cam thể thao năng động (Orange)
    }
    if (lowerBadge.contains('thảo')) {
      return const Color(0xFF0D47A1); // Xanh dương tri thức (Blue)
    }
    if (lowerBadge.contains('lãm')) {
      return const Color(0xFF4A148C); // Tím nghệ thuật, triển lãm (Purple)
    }
    if (lowerBadge.contains('rằm')) {
      return const Color(0xFFFFB300); // Vàng trung thu rực rỡ (Amber)
    }

    // Thuật toán băm dự phòng nếu phát sinh badge mới (Đã tinh chỉnh để ra màu sáng đẹp)
    int hash = 0;
    for (int i = 0; i < badge.length; i++) {
      hash = badge.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return HSLColor.fromColor(Color((hash & 0x00FFFFFF) | 0xFF000000))
        .withLightness(0.4) // Giữ độ sáng vừa phải để thấy rõ chữ trắng
        .withSaturation(0.7) // Giữ màu sắc tươi tắn
        .toColor();
  }

  // 5. Cố định màu nền Card về màu trung tính cao cấp (Sạch sẽ, tôn ảnh banner)
  Color get dynamicCardColor {
    return const Color(0xFFF8F9FA); // Xám trắng sữa siêu nhẹ chống mỏi mắt
  }

  static EventResponse fromJson(String json) {
    return EventResponseMapper.fromJson(json);
  }

  static EventResponse fromMap(Map<String, dynamic> map) {
    return EventResponseMapper.fromMap(map);
  }
}
