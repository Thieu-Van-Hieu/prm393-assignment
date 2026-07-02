import 'package:my_fschool_frontend/api/club_api.dart';
import 'package:my_fschool_frontend/model/response/student_clubs_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'club_notifier.g.dart';

@Riverpod(keepAlive: true)
class ClubNotifier extends _$ClubNotifier {
  final _clubApi = ClubApi();

  @override
  FutureOr<StudentClubsResponse> build() async {
    return StudentClubsResponse(joinedClubs: [], unjoinedClubs: []);
  }

  Future<void> fetchStudentClubs(
    String studentId, {
    bool isSilent = true,
  }) async {
    if (!isSilent) {
      state = const AsyncLoading();
    }

    final result = await _clubApi.getStudentClubs(studentId);
    if (result.hasError) {
      state = AsyncValue.error(
        Exception(result.errorMessage ?? 'Không thể kết nối tới máy chủ'),
        StackTrace.current,
      );
      return;
    }

    state = AsyncValue.data(
      result.data ?? StudentClubsResponse(joinedClubs: [], unjoinedClubs: []),
    );
  }
}
