import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/widget/input/app_bottom_sheet.dart';
import 'package:my_fschool_frontend/widget/transcript/semester_sheet_content.dart';

class SemesterSelectorBar extends StatelessWidget {
  final String currentSemester;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const SemesterSelectorBar({
    super.key,
    required this.currentSemester,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomSheet.show(
          context: context,
          title: 'Chọn Học kỳ & Năm học',
          content: SemesterSheetContent(
            options: options,
            currentSemester: currentSemester,
            onChanged: onChanged,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Asap',
                  fontSize: 15,
                  color: Colors.grey,
                ),
                children: [
                  const TextSpan(text: 'Kết quả của: '),
                  TextSpan(
                    text: currentSemester,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_drop_down_circle_outlined,
              size: 18,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
