import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/enum/subject_type.dart';
import 'package:my_fschool_frontend/model/response/academic_grade_response.dart';

class SubjectGradeCard extends StatelessWidget {
  final AcademicGradeResponse record;

  const SubjectGradeCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isNumeric = record.type == SubjectType.numeric;

    Color badgeColor = Colors.green;
    String badgeText = '';

    if (isNumeric) {
      badgeText = record.summaryScore?.toString() ?? '';
      if ((record.summaryScore ?? 0) < 6.5) {
        badgeColor = const Color(0xFFFF5722);
      }
    } else {
      badgeText = record.qualitativeResult ?? 'Đạt';
      badgeColor = record.qualitativeResult == 'Đạt'
          ? Colors.green
          : Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.subjectName,
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFECEFF1), height: 1),
            const SizedBox(height: 14),
            if (isNumeric) ...[
              Row(
                children: [
                  _buildScoreBlock(
                    'Thường Xuyên',
                    record.regularScores?.join(', ') ?? '-',
                  ),
                  const SizedBox(width: 10),
                  _buildScoreBlock(
                    'Giữa kỳ',
                    record.midTermScore?.toString() ?? '-',
                  ),
                  const SizedBox(width: 10),
                  _buildScoreBlock(
                    'Cuối kỳ',
                    record.finalTermScore?.toString() ?? '-',
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 13,
                    color: Color(0xFF5D4037),
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Nhận xét: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: record.teacherComment),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBlock(String title, String scores) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Asap',
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              scores,
              style: const TextStyle(
                fontFamily: 'Asap',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37474F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
