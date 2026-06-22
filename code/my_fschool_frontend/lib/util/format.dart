import 'package:flutter/cupertino.dart';

String formatTime(String? raw) {
  if (raw == null || raw.isEmpty) return '--:--';
  try {
    DateTime parsedTime;

    if (raw.endsWith('Z')) {
      String cleanRaw = raw.substring(0, raw.length - 1).replaceAll(' ', 'T');

      parsedTime = DateTime.parse("$cleanRaw+00:00").toLocal();
    } else {
      parsedTime = DateTime.parse(raw).toLocal();
    }

    if (raw.length >= 16) {}

    String hour = parsedTime.hour.toString().padLeft(2, '0');
    String minute = parsedTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  } catch (e) {
    debugPrint('Lỗi parse giờ: $e');
    return '--:--';
  }
}
