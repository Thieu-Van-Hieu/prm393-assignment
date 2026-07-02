import 'package:my_fschool_frontend/api/event_api.dart';
import 'package:my_fschool_frontend/model/request/event_registration_request.dart';
import 'package:my_fschool_frontend/model/response/event_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  final _eventApi = EventApi();

  @override
  FutureOr<List<EventResponse>> build() async {
    return [];
  }

  Future<void> fetchEvents({bool isSilent = true}) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    final result = await _eventApi.getEvents();

    if (result.hasError) {
      state = AsyncValue.error(
        Exception(result.errorMessage ?? 'Không thể kết nối tới máy chủ'),
        StackTrace.current,
      );
      return;
    }

    state = AsyncValue.data(result.data ?? []);
  }

  Future<void> registerEvent({
    required EventRegistrationRequest eventRegistrationRequest,
    bool isSilent = false,
  }) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    final result = await _eventApi.register(eventRegistrationRequest);

    if (result.hasError) {
      state = AsyncValue.error(
        Exception(result.errorMessage ?? 'Không thể kết nối tới máy chủ'),
        StackTrace.current,
      );
      return;
    }

    // Sau khi đăng ký thành công, bạn có thể gọi lại fetchEvents để cập nhật danh sách sự kiện
    await fetchEvents(isSilent: true);
  }
}
