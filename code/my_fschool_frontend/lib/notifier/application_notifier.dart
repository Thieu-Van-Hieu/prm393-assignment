import 'dart:async';

import 'package:my_fschool_frontend/api/application_api.dart';
import 'package:my_fschool_frontend/model/response/application_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_notifier.g.dart';

@Riverpod(keepAlive: true)
class ApplicationNotifier extends _$ApplicationNotifier {
  final _applicationApi = ApplicationApi();

  @override
  FutureOr<List<ApplicationResponse>> build() async {
    final records = await _applicationApi.getApplicationsByParent();
    return records.data ?? [];
  }

  /// 🎯 Lấy danh sách đơn từ của Phụ huynh nộp (gọi từ màn hình chính)
  Future<void> fetchParentApplications({bool isSilent = false}) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    try {
      final records = await _applicationApi.getApplicationsByParent();

      state = AsyncValue.data(records.data ?? []);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// 🎯 Lấy danh sách đơn từ dành cho Giáo viên quản lý
  Future<void> fetchManageApplications({bool isSilent = false}) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    try {
      final records = await _applicationApi.getApplicationsByParent();

      state = AsyncValue.data(records.data ?? []);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
