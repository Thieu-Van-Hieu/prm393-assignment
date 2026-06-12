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

  // 🆕 TÁCH HÀM RIÊNG THEO Ý PHEN:
  // Hàm này xử lý logic gọi API, dùng được cho cả lần đầu lẫn các lần chạy ngầm sau này
  Future<void> fetchUserProfile({bool isSilent = false}) async {
    // Nếu không phải chạy ngầm (gọi lần đầu), ta chủ động bật trạng thái loading cho UI biết
    if (!isSilent) {
      state = const AsyncLoading();
    }

    // Tiến hành gọi API dưới nền
    final result = await _authApi.me();

    if (result.hasError) {
      // Nếu lỗi, đẩy lỗi vào state để UI hiển thị màn hình Error
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
