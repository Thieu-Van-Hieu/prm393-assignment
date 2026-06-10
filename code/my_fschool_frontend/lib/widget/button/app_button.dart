import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

enum AppButtonType { primary, secondary, danger, info }

enum AppButtonStyle { filled, tonal, outline, text }

enum AppButtonSize { small, medium, big }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonStyle style;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.style = AppButtonStyle.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------
    // 1. TÍNH TOÁN KÍCH THƯỚC (SIZE)
    // ----------------------------------------------------
    double height;
    double fontSize;
    EdgeInsetsGeometry padding;

    switch (size) {
      case AppButtonSize.small:
        height = 48.0;
        fontSize = 16.0;
        padding = const EdgeInsets.symmetric(horizontal: 12);
        break;
      case AppButtonSize.medium:
        height = 56.0;
        fontSize = 20.0;
        padding = const EdgeInsets.symmetric(horizontal: 16);
        break;
      case AppButtonSize.big:
        height = 64.0;
        fontSize = 24.0;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        break;
    }

    // ----------------------------------------------------
    // 2. LẤY MÀU GỐC THEO NGỮ CẢNH (TYPE)
    // ----------------------------------------------------
    Color baseColor;
    switch (type) {
      case AppButtonType.primary:
        baseColor = AppColors.buttonPrimary;
        break;
      case AppButtonType.secondary:
        baseColor = AppColors.buttonSecondary;
        break;
      case AppButtonType.danger:
        baseColor = AppColors.danger; // Lấy thẳng màu đỏ hệ thống
        break;
      case AppButtonType.info:
        baseColor = AppColors.info;
        break;
    }

    // ----------------------------------------------------
    // 3. ĐỘNG HÓA MÀU SẮC THEO STYLE (Tonal, Filled, Outline, Text)
    // ----------------------------------------------------
    Color backgroundColor = Colors.transparent;
    Color textColor = AppColors.textButton;
    BorderSide borderSide = BorderSide.none;
    double elevation = 0;

    if (onPressed == null) {
      // Trạng thái Bị Disable
      backgroundColor =
          (style == AppButtonStyle.filled || style == AppButtonStyle.tonal)
          ? AppColors.inputBorder
          : Colors.transparent;
      textColor = AppColors.textSecondary;
      borderSide = style == AppButtonStyle.outline
          ? const BorderSide(color: AppColors.inputBorder, width: 1.5)
          : BorderSide.none;
    } else {
      // Trạng thái Hoạt động bình thường
      switch (style) {
        case AppButtonStyle.filled:
          backgroundColor = baseColor;
          textColor = AppColors.textButton; // Chữ trắng nổi bật
          elevation = type == AppButtonType.primary ? 2.0 : 1.0;
          break;

        case AppButtonStyle.tonal:
          // 🆕 Nền lấy màu gốc hạ opacity xuống 12% (alpha: 0.12), chữ lấy full màu gốc rực rỡ
          backgroundColor = baseColor.withValues(alpha: 0.12);
          textColor = baseColor;
          elevation = 0.0; // Tonal style thường để phẳng không đổ bóng
          break;

        case AppButtonStyle.outline:
          backgroundColor = Colors.transparent;
          textColor = baseColor;
          borderSide = BorderSide(color: baseColor, width: 1.5);
          break;

        case AppButtonStyle.text:
          backgroundColor = Colors.transparent;
          textColor = baseColor;
          break;
      }
    }

    // ----------------------------------------------------
    // 4. NỘI DUNG NÚT (CONTENT)
    // ----------------------------------------------------
    Widget buttonContent = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 2, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Asap',
                ),
              ),
            ],
          );

    return SizedBox(
      width: width ?? (style == AppButtonStyle.text ? null : double.infinity),
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          padding: padding,
          side: borderSide,
          shadowColor: baseColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}
