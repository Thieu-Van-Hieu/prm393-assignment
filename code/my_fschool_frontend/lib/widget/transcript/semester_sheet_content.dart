import 'package:flutter/material.dart';

class SemesterSheetContent extends StatelessWidget {
  final List<String> options;
  final String currentSemester;
  final ValueChanged<String> onChanged;

  const SemesterSheetContent({
    super.key,
    required this.options,
    required this.currentSemester,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.map((semester) {
        final isSelected = semester == currentSemester;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            // Nếu chọn thì tô màu nền cam cực nhẹ, chưa chọn thì màu trắng xám nhẹ
            color: isSelected
                ? Colors.orange.withValues(alpha: 0.08)
                : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            // Thêm viền mỏng để phân biệt rõ ràng các ô
            border: Border.all(
              color: isSelected
                  ? Colors.orange.withValues(alpha: 0.5)
                  : const Color(0xFFE9ECEF),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              semester,
              style: TextStyle(
                fontFamily: 'Asap',
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.orange : const Color(0xFF2D3142),
              ),
            ),
            // Đưa dấu check sang bên phải nhìn cho thoáng
            trailing: isSelected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.orange,
                    size: 22,
                  )
                : const Icon(
                    Icons.circle_outlined,
                    color: Color(0xFFCED4DA),
                    size: 22,
                  ),
            onTap: () {
              onChanged(semester);
              Navigator.pop(context);
            },
          ),
        );
      }).toList(),
    );
  }
}
