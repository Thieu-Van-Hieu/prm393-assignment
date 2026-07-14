import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/response/event_response.dart';

class EventCard extends StatelessWidget {
  final EventResponse event;
  final VoidCallback onRegisterPressed;

  const EventCard({
    super.key,
    required this.event,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final imageBytes = event.memoryImage;
    final bool isRegistered =
        event.isRegistered; // An toàn nếu trường này bị null

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: event.dynamicCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRegistered
              ? const Color(0xFFC2E7D9)
              : const Color(0xFFE3EDF5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Khối hiển thị Badge phân loại & Trạng thái đăng ký
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge phân loại sự kiện
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: event.dynamicPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.badge,
                        style: const TextStyle(
                          fontFamily: 'Asap',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // 🌟 Badge "Đã đăng ký" hiển thị ở góc phải nếu người dùng đã tham gia
                    if (isRegistered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9), // Nền xanh lá nhạt
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF81C784),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Color(0xFF2E7D32),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Đã đăng ký',
                              style: TextStyle(
                                fontFamily: 'Asap',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Khu vực hình ảnh
                Center(
                  child: imageBytes != null
                      ? Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    event.fallbackIcon,
                                    size: 72,
                                    color: event.dynamicPrimaryColor,
                                  ),
                            ),
                          ),
                        )
                      : Icon(
                          event.fallbackIcon,
                          size: 72,
                          color: event.dynamicPrimaryColor,
                        ),
                ),
                const SizedBox(height: 16),

                // 3. Tiêu đề Sự kiện
                Text(
                  event.title,
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Khối danh sách thuộc tính động (Thời gian, Địa điểm,...)
                ...event.eventProperties.map((prop) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${prop.propertyName} ',
                          style: const TextStyle(
                            fontFamily: 'Asap',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            prop.propertyValue,
                            style: const TextStyle(
                              fontFamily: 'Asap',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // 5. Nút bấm Đăng ký chỉ hiển thị khi: Sự kiện sắp diễn ra VÀ CHƯA đăng ký
          if (event.isUpcoming && !isRegistered) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Đăng ký tham gia',
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
