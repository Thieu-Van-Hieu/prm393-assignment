import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/response/student_profile_response.dart';
import 'package:my_fschool_frontend/notifier/user_profile_notifier.dart';
import 'package:my_fschool_frontend/provider/workspace_index_provider.dart';
import 'package:my_fschool_frontend/util/format.dart';
import 'package:my_fschool_frontend/widget/dashboard/attendance_status_card.dart';
import 'package:my_fschool_frontend/widget/dashboard/child_list_sheet_content.dart';
import 'package:my_fschool_frontend/widget/dashboard/club_activity_card.dart';
import 'package:my_fschool_frontend/widget/dashboard/student_profile_card.dart';
import 'package:my_fschool_frontend/widget/dashboard/utility_grid.dart';
import 'package:my_fschool_frontend/widget/input/app_bottom_sheet.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChildIndex = ref.watch(selectedWorkspaceIndexProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    useEffect(() {
      Future.microtask(() {
        final hasData =
            userProfileAsync.hasValue && userProfileAsync.value != null;

        if (!hasData) {
          ref
              .read(userProfileProvider.notifier)
              .fetchUserProfile(isSilent: false);
        } else {
          ref
              .read(userProfileProvider.notifier)
              .fetchUserProfile(isSilent: true);
        }
      });
      return null;
    }, []);

    return userProfileAsync.when(
      skipLoadingOnReload: true,
      loading: () => const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: CircularProgressIndicator(color: AppColors.orangeFPT),
          ),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              err.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontFamily: 'Asap', fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (userResponse) {
        if (userResponse == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.orangeFPT),
            ),
          );
        }

        // 🎯 THAY ĐỔI: Lấy danh sách không gian làm việc mới
        final workspaces = userResponse.userWorkspaceResponses;

        // Kiểm tra an toàn chỉ mục (index) để tránh lỗi vỡ màn hình do out of bounds
        int safeIndex = selectedChildIndex;
        if (safeIndex >= workspaces.length) {
          safeIndex = 0;
        }

        StudentProfileResponse? activeProfile;
        String currentRole = 'STUDENT';
        String currentClassName = 'Chưa xếp lớp';

        // 🎯 THAY ĐỔI: Bốc trực tiếp context dựa theo cấu trúc phẳng hóa mới
        if (workspaces.isNotEmpty) {
          final activeWorkspace = workspaces[safeIndex];
          activeProfile = activeWorkspace.profile;
          currentRole = activeWorkspace.roleName;
          currentClassName = activeWorkspace.className;
        }

        if (activeProfile == null) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Không tìm thấy dữ liệu hồ sơ học sinh liên kết cho không gian lớp học này.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // 🎯 THAY ĐỔI: Chỉ ẩn nút đổi nếu danh sách lớp có từ 1 phần tử trở xuống
        final showSwitchButton = workspaces.length > 1;

        // Chuẩn hóa dữ liệu điểm danh hôm nay
        String attendanceStatusText = 'Chưa có dữ liệu điểm danh';
        final String? recordedAtRaw = activeProfile.todayAttendance?.recordedAt
            .toString();
        String attendanceTimeText = '--:--';

        if (activeProfile.todayAttendance != null) {
          final status = activeProfile.todayAttendance!.status;

          if (status == 'ATTENDED') {
            attendanceStatusText = 'Đã điểm danh đến lớp';
            attendanceTimeText = formatTime(recordedAtRaw);
          } else if (status == 'ABSENT') {
            attendanceStatusText = 'Học sinh vắng mặt hôm nay';
            attendanceTimeText = formatTime(recordedAtRaw);
          } else if (status == 'PENDING') {
            attendanceStatusText = 'Đang chờ điểm danh';
            attendanceTimeText = 'Chờ ghi nhận';
          }
        }

        return RefreshIndicator(
          color: AppColors.orangeFPT,
          onRefresh: () => ref
              .read(userProfileProvider.notifier)
              .fetchUserProfile(isSilent: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Thẻ thông tin học sinh
                StudentProfileCard(
                  studentName: activeProfile.fullName,
                  className: currentClassName,
                  avatarUrl: activeProfile.avatarUrl,
                  showSwitchButton: showSwitchButton,
                  onSwitchPressed: () => {
                    AppBottomSheet.show(
                      context: context,
                      title: "Chọn không gian lớp học",
                      content: ChildListSheetContent(
                        userResponse: userResponse,
                        initialSelectedIndex: safeIndex,
                        onChildSelected: (index) {
                          ref
                                  .read(selectedWorkspaceIndexProvider.notifier)
                                  .state =
                              index;
                        },
                      ),
                    ),
                  },
                ),
                const SizedBox(height: 20),

                // 2. Banner trạng thái điểm danh hôm nay
                AttendanceStatusCard(
                  statusText: attendanceStatusText,
                  recordTime: attendanceTimeText,
                  status: activeProfile.todayAttendance?.status,
                ),
                const SizedBox(height: 24),

                // 3. Tiêu đề mục Tiện ích
                const Text(
                  'Tiện ích',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Asap',
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Lưới chức năng
                const UtilityGrid(),
                const SizedBox(height: 16),
                ClubActivityCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}
