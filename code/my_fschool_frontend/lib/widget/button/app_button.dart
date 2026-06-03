import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';

enum AppButtonType { primary, secondary, outline, text }

enum AppButtonSize { small, medium, big }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Tính toán Chiêu cao & FontSize dựa trên Size
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

    // 2. Tính toán Màu sắc dựa trên Type
    Color backgroundColor = Colors.transparent;
    Color textColor = AppColors.textButton;
    BorderSide borderSide = BorderSide.none;
    double elevation = 0;

    if (onPressed == null) {
      backgroundColor = AppColors.inputBorder;
      textColor = AppColors.textSecondary;
    } else {
      switch (type) {
        case AppButtonType.primary:
          backgroundColor = AppColors.buttonPrimary;
          textColor = AppColors.textButton;
          elevation = 2.0; // Đổ bóng nhẹ cho nút bấm chính theo mockup
          break;
        case AppButtonType.secondary:
          backgroundColor = AppColors.buttonSecondary;
          textColor = AppColors.textButton;
          elevation = 1.0;
          break;
        case AppButtonType.outline:
          backgroundColor = Colors.transparent;
          textColor = AppColors.orangeFPT;
          borderSide = const BorderSide(color: AppColors.orangeFPT, width: 1.5);
          break;
        case AppButtonType.text:
          backgroundColor = Colors.transparent;
          textColor = AppColors.blueFPT;
          break;
      }
    }

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
      width: width ?? (type == AppButtonType.text ? null : double.infinity),
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          padding: padding,
          side: borderSide,
          shadowColor: AppColors.orangeFPT.withValues(alpha: 0.4),
          // Màu bóng đổ cam mờ đẹp mắt
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}
