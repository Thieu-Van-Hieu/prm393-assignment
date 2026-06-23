import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/notifier/transcript_notifier.dart';
import 'package:my_fschool_frontend/provider/workspace_index_provider.dart';
import 'package:my_fschool_frontend/widget/transcript/semester_selector_bar.dart';
import 'package:my_fschool_frontend/widget/transcript/subject_grade_card.dart';

class TranscriptScreen extends HookConsumerWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    final studentId = activeWorkspace?.profile.id;
    final transcriptAsync = ref.watch(transcriptProvider);
    final selectedSemester = useState<String?>(null);

    useEffect(() {
      if (studentId == null) return null;

      Future.microtask(
        () => ref
            .read(transcriptProvider.notifier)
            .fetchSemesterTranscripts(studentId: studentId),
      );

      selectedSemester.value = null;
      return null;
    }, [studentId]);

    return Column(
      children: [
        transcriptAsync.when(
          data: (transcriptList) {
            if (transcriptList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text(
                    'Chưa có dữ liệu bảng điểm học kỳ nào.',
                    style: TextStyle(fontFamily: 'Asap', color: Colors.grey),
                  ),
                ),
              );
            }

            final List<String> semesterOptions = transcriptList
                .map((e) => e.semesterName)
                .toList();

            if (selectedSemester.value == null && semesterOptions.isNotEmpty) {
              selectedSemester.value = semesterOptions.first;
            }

            final currentSemesterData = transcriptList.firstWhere(
              (e) => e.semesterName == selectedSemester.value,
              orElse: () => transcriptList.first,
            );

            final currentRecords = currentSemesterData.academicGrades;

            return Expanded(
              child: Column(
                children: [
                  // 🎯 Sử dụng Widget chọn học kỳ riêng biệt
                  SemesterSelectorBar(
                    currentSemester: selectedSemester.value ?? '',
                    options: semesterOptions,
                    onChanged: (newValue) => selectedSemester.value = newValue,
                  ),

                  // Danh sách môn học
                  Expanded(
                    child: currentRecords.isEmpty
                        ? const Center(
                            child: Text(
                              'Học kỳ này chưa có điểm môn học nào.',
                              style: TextStyle(
                                fontFamily: 'Asap',
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: currentRecords.length,
                            itemBuilder: (context, index) {
                              // 🎯 Sử dụng Card môn học riêng biệt
                              return SubjectGradeCard(
                                record: currentRecords[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          ),
          error: (err, stack) => Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đã xảy ra lỗi khi tải bảng điểm 😢',
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    err.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
