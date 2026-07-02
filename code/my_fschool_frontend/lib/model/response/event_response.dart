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
        base64Image!.contains('_holder')) {
      return null;
    }
    try {
      return base64Decode(base64Image!);
    } catch (_) {
      return null;
    }
  }

  // 3. Fallback Icon thông minh dựa trên tên phân loại của Badge
  IconData get fallbackIcon {
    final lowerBadge = badge.toLowerCase();
    if (lowerBadge.contains('thao') ||
        lowerBadge.contains('bơi') ||
        lowerBadge.contains('sport')) {
      return Icons.pool_rounded;
    }
    if (lowerBadge.contains('trại') || lowerBadge.contains('văn hóa')) {
      return Icons.gite_rounded;
    }
    if (lowerBadge.contains('học') || lowerBadge.contains('thi')) {
      return Icons.menu_book_rounded;
    }
    return Icons.star_rounded; // Mặc định nếu không khớp từ khóa
  }

  // 4. Giải thuật băm màu sắc động dựa vào text của Badge (Không lo hardcode)
  Color get dynamicPrimaryColor {
    int hash = 0;
    for (int i = 0; i < badge.length; i++) {
      hash = badge.codeUnitAt(i) + ((hash << 5) - hash);
    }
    // Tạo màu từ mã băm và ép độ sáng vừa phải để làm tông màu chính
    return Color((hash & 0x00FFFFFF) | 0xFF000000).withValues(alpha: 0.85);
  }

  // 5. Cố định màu nền Card về màu trung tính cao cấp (Sạch sẽ, tôn ảnh banner)
  Color get dynamicCardColor {
    return const Color(0xFFF4F6F9); // Màu xám trắng sữa trung tính cực sạch
  }

  static EventResponse fromJson(String json) {
    return EventResponseMapper.fromJson(json);
  }

  static EventResponse fromMap(Map<String, dynamic> map) {
    return EventResponseMapper.fromMap(map);
  }
}
