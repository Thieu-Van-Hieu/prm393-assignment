import 'dart:async';

import 'package:my_fschool_frontend/api/auth_api.dart';
import 'package:my_fschool_frontend/model/response/user_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  final _authApi = AuthApi();

  @override
  FutureOr<UserResponse?> build() async {
    return null;
  }

  Future<void> fetchUserProfile({bool isSilent = false}) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    final result = await _authApi.me();

    if (result.hasError) {
      state = AsyncValue.error(
        Exception(result.errorMessage ?? 'Không thể kết nối tới máy chủ'),
        StackTrace.current,
      );
      return;
    }

    // Thành công: Đắp dữ liệu mới vào state, UI tự động cập nhật mượt mà
    state = AsyncValue.data(result.data);
  }
}
