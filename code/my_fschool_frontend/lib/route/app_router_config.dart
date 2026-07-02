import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/screen/application_screen.dart';
import 'package:my_fschool_frontend/screen/dashboard_screen.dart';
import 'package:my_fschool_frontend/screen/event_screen.dart';
import 'package:my_fschool_frontend/screen/profile_screen.dart';
import 'package:my_fschool_frontend/screen/schedule_screen.dart';
import 'package:my_fschool_frontend/screen/transcript_screen.dart';

class AppRouteMeta {
  final String title;
  final int tabIndex;
  final bool hasBackButton;
  final bool isNavBarItem;
  final IconData? icon;
  final IconData? selectedIcon;
  final Widget Function(BuildContext, GoRouterState) builder;

  const AppRouteMeta({
    required this.title,
    required this.tabIndex,
    required this.hasBackButton,
    this.isNavBarItem = true,
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
      builder: (context, state) => DashboardScreen(),
    ),
    '/schedule': AppRouteMeta(
      title: 'Thời khóa biểu',
      tabIndex: 1,
      hasBackButton: false,
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      builder: (context, state) => ScheduleScreen(),
    ),
    '/grades': AppRouteMeta(
      title: 'Bảng điểm',
      tabIndex: 2,
      hasBackButton: false,
      icon: Icons.stars_outlined,
      selectedIcon: Icons.stars,
      builder: (context, state) => TranscriptScreen(),
    ),
    '/profile': AppRouteMeta(
      title: 'Tài khoản',
      tabIndex: 3,
      hasBackButton: false,
      icon: Icons.account_circle_outlined,
      selectedIcon: Icons.account_circle,
      builder: (context, state) => const Center(child: ProfileScreen()),
    ),
    '/application': AppRouteMeta(
      title: 'Đơn từ',
      tabIndex: 0,
      hasBackButton: true,
      isNavBarItem: false,
      builder: (context, state) => ApplicationScreen(),
    ),
    '/event': AppRouteMeta(
      title: 'Sự kiện',
      tabIndex: 0,
      hasBackButton: true,
      isNavBarItem: false,
      builder: (context, state) => EventScreen(),
    ),
    '/club': AppRouteMeta(
      title: 'Chi tiết câu lạc bộ',
      tabIndex: 0,
      hasBackButton: true,
      isNavBarItem: false,
      builder: (context, state) =>
          const Center(child: Text('Nội dung chi tiết câu lạc bộ')),
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
