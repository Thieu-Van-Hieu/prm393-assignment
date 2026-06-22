import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/notifier/schedule_notifier.dart';
import 'package:my_fschool_frontend/provider/workspace_index_provider.dart';
import 'package:my_fschool_frontend/widget/schedule/schedule_card.dart';

import '../widget/schedule/calendar_header_bar.dart';
import '../widget/schedule/week_controller_bar.dart';

class ScheduleScreen extends HookConsumerWidget {
  const ScheduleScreen({super.key});

  List<DateTime> _getDaysInWeek(DateTime date) {
    final int currentDayOfWeek = date.weekday;
    final DateTime startOfWeek = date.subtract(
      Duration(days: currentDayOfWeek - 1),
    );
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState<DateTime>(DateTime.now());
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    final studentId = activeWorkspace?.profile.id;
    final scheduleAsync = ref.watch(scheduleProvider);

    useEffect(() {
      if (studentId == null) return null;

      Future.microtask(() {
        ref
            .read(scheduleProvider.notifier)
            .fetchStudentSchedule(
              studentId: studentId,
              date: selectedDate.value,
              isSilent: scheduleAsync.hasValue,
            );
      });
      return null;
    }, [selectedDate.value, studentId]);

    if (studentId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Không tìm thấy thông tin học sinh.',
            style: TextStyle(
              fontFamily: 'Asap',
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // 🎯 Controller chuyển tuần
        WeekControllerBar(
          selectedDate: selectedDate,
          getDaysInWeek: _getDaysInWeek,
        ),

        // 📅 Header hiển thị Thứ / Ngày
        CalendarHeaderBar(
          selectedDate: selectedDate,
          getDaysInWeek: _getDaysInWeek,
        ),

        const SizedBox(height: 8),

        // 📚 Danh sách lịch học render qua .when
        Expanded(
          child: scheduleAsync.when(
            skipLoadingOnReload: true,
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.orangeFPT),
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    err.toString().replaceAll('Exception: ', ''),
                    style: const TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 15,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(scheduleProvider.notifier)
                        .fetchStudentSchedule(
                          studentId: studentId,
                          date: selectedDate.value,
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeFPT,
                    ),
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            data: (schedules) {
              if (schedules.isEmpty) {
                return const Center(
                  child: Text(
                    'Không có lịch học nào trong ngày này.',
                    style: TextStyle(
                      fontFamily: 'Asap',
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  return ScheduleCard(item: schedules[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
