import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/screen/profile_screen.dart';

class AppRouteMeta {
  final String title;
  final int tabIndex;
  final bool hasBackButton;
  final IconData? icon;
  final IconData? selectedIcon;
  final Widget Function(BuildContext, GoRouterState) builder;

  const AppRouteMeta({
    required this.title,
    required this.tabIndex,
    required this.hasBackButton,
    this.icon,
    this.selectedIcon,
    required this.builder,
  });

  static final Map<String, AppRouteMeta> appRouterConfig = {
    '/dashboard': AppRouteMeta(
      title: 'Trang chủ',
      tabIndex: 0,
      hasBackButton: false,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_filled,
      builder: (context, state) =>
          const Center(child: Text('Màn hình Dashboard Phụ Huynh')),
    ),
    '/schedule': AppRouteMeta(
      title: 'Thời khóa biểu',
      tabIndex: 1,
      hasBackButton: false,
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      builder: (context, state) =>
          const Center(child: Text('Màn hình Thời khóa biểu')),
    ),
    '/grades': AppRouteMeta(
      title: 'Bảng điểm',
      tabIndex: 2,
      hasBackButton: false,
      icon: Icons.stars_outlined,
      selectedIcon: Icons.stars,
      builder: (context, state) =>
          const Center(child: Text('Màn hình Bảng điểm')),
    ),
    '/profile': AppRouteMeta(
      title: 'Tài khoản',
      tabIndex: 3,
      hasBackButton: false,
      icon: Icons.account_circle_outlined,
      selectedIcon: Icons.account_circle,
      builder: (context, state) => const Center(child: ProfileScreen()),
    ),
    '/dashboard/attendance-detail': AppRouteMeta(
      title: 'Chi tiết điểm danh',
      tabIndex: -1, // Trang con không hiển thị trên Navbar
      hasBackButton: true,
      builder: (context, state) =>
          const Center(child: Text('Nội dung chi tiết điểm danh')),
    ),
  };

  static AppRouteMeta getMetaForLocation(String location) {
    if (appRouterConfig.containsKey(location)) {
      return appRouterConfig[location]!;
    }
    for (var key in appRouterConfig.keys) {
      if (key != '/' && location.startsWith(key)) {
        return appRouterConfig[key]!;
      }
    }
    return AppRouteMeta(
      title: 'FPT School',
      tabIndex: -1,
      hasBackButton: true,
      builder: (context, state) => const Center(child: Text('404 Not Found')),
    );
  }
}
