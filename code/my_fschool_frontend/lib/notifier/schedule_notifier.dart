import 'dart:async';

import 'package:my_fschool_frontend/api/schedule_api.dart';
import 'package:my_fschool_frontend/model/response/schedule_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_notifier.g.dart';

@Riverpod(keepAlive: true)
class ScheduleNotifier extends _$ScheduleNotifier {
  final _scheduleApi = ScheduleApi();

  @override
  FutureOr<List<ScheduleResponse>> build() async {
    // Mặc định ban đầu chưa gọi gì thì trả về danh sách rỗng sạch đẹp
    return [];
  }

  /// Hàm lôi lịch học từ API đổ thẳng vào State hệ thống
  /// - [isSilent]: Nếu `true`, app âm thầm cập nhật ngầm dưới nền mà không bật loading che màn hình
  Future<void> fetchStudentSchedule({
    required String studentId,
    required DateTime date,
    bool isSilent = false,
  }) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    final result = await _scheduleApi.getStudentSchedule(
      studentId: studentId,
      date: date,
    );

    if (result.hasError) {
      state = AsyncValue.error(
        Exception(result.errorMessage ?? 'Không thể kết nối tới máy chủ'),
        StackTrace.current,
      );
      return;
    }

    state = AsyncValue.data(result.data ?? []);
  }
}
