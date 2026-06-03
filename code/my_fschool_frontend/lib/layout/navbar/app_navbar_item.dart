import 'package:flutter/material.dart';

class AppNavbarItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String initialPath; // Đường dẫn tương ứng với route của tab đó

  const AppNavbarItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.initialPath,
  });
}
