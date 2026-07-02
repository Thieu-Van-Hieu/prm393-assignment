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

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: event.dynamicCardColor,
        borderRadius: BorderRadius.circular(16),
        // 🌟 Thêm viền nhẹ bao quanh card để tạo ranh giới UI rõ ràng
        border: Border.all(color: const Color(0xFFE3EDF5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Khối hiển thị phân loại Badge tên ngắn gọn
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
                const SizedBox(height: 16),

                // 2. Khu vực hình ảnh: Phóng to ra và bao phủ toàn bộ chiều rộng
                Center(
                  child: imageBytes != null
                      ? Container(
                          width: double.infinity,
                          height: 160, // 🌟 Tăng size ảnh to rõ ràng hơn
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

          // 5. Nút bấm Đăng ký nếu sự kiện chưa kết thúc
          if (event.isUpcoming) ...[
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
