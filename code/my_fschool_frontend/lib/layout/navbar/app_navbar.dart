import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/route/app_router_config.dart';

class AppNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavbar({super.key, required this.currentIndex, required this.onTap});

  // Hàm Helper: Lọc các route chính và sắp xếp theo đúng thứ tự tabIndex từ 0 -> 3
  static List<MapEntry<String, AppRouteMeta>> navItems() {
    final navEntries = AppRouteMeta.appRouterConfig.entries
        .where(
          (entry) => entry.value.tabIndex != -1,
        ) // Chỉ lấy các trang thuộc menu
        .toList();

    // Sắp xếp tăng dần theo tabIndex để tránh việc thứ tự khai báo trong map làm đảo lộn UI
    navEntries.sort((a, b) => a.value.tabIndex.compareTo(b.value.tabIndex));
    return navEntries;
  }

  @override
  Widget build(BuildContext context) {
    final items = navItems();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.orangeFPT,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Asap',
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: 'Asap'),
        items: items.map((entry) {
          final meta = entry.value;
          return BottomNavigationBarItem(
            // Dùng toán tử ?? để phòng trường hợp quên không khai báo icon trong Meta
            icon: Icon(meta.icon ?? Icons.circle_outlined),
            activeIcon: Icon(meta.selectedIcon ?? Icons.circle),
            label: meta.title,
          );
        }).toList(),
      ),
    );
  }
}
