import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/notifier/club_notifier.dart';
import 'package:my_fschool_frontend/provider/workspace_index_provider.dart';
import 'package:my_fschool_frontend/widget/club/club_card.dart';

class ClubScreen extends HookConsumerWidget {
  const ClubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lấy thông tin studentId từ activeWorkspace giống bên Schedule
    final activeWorkspace = ref.watch(activeWorkspaceProvider);
    final studentId = activeWorkspace?.profile.id;

    // 2. Lấy trạng thái dữ liệu câu lạc bộ từ Provider
    final clubsAsync = ref.watch(clubProvider);

    // 3. Tự động fetch data khi màn hình được init hoặc studentId thay đổi
    useEffect(() {
      if (studentId == null) return null;

      Future.microtask(() {
        ref
            .read(clubProvider.notifier)
            .fetchStudentClubs(studentId, isSilent: true);
      });
      return null;
    }, [studentId]);

    // Nếu chưa chọn workspace hoặc chưa có profile hợp lệ
    if (studentId == null) {
      return const Center(
        child: Text(
          'Không tìm thấy thông tin học sinh.',
          style: TextStyle(fontFamily: 'Asap', color: Colors.grey),
        ),
      );
    }

    // 4. Render giao diện dựa trên trạng thái AsyncValue
    return clubsAsync.when(
      data: (clubsData) {
        final joinedClubs = clubsData.joinedClubs;
        final otherClubs = clubsData.unjoinedClubs;

        if (joinedClubs.isEmpty && otherClubs.isEmpty) {
          return const Center(
            child: Text(
              'Hiện tại chưa có câu lạc bộ nào.',
              style: TextStyle(
                fontFamily: 'Asap',
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFFF5722),
          onRefresh: () => ref
              .read(clubProvider.notifier)
              .fetchStudentClubs(studentId, isSilent: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= KHỐI 1: CÁC CÂU LẠC BỘ ĐANG THAM GIA =================
                if (joinedClubs.isNotEmpty) ...[
                  const Text(
                    'CÁC CÂU LẠC BỘ ĐANG THAM GIA',
                    style: TextStyle(
                      fontFamily: 'Asap',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5722),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...joinedClubs.map(
                    (club) => ClubCard(club: club, isJoined: true),
                  ),
                ],

                const SizedBox(height: 8),

                // ================= KHỐI 2: CÁC CÂU LẠC BỘ TẠI FPT SCHOOL =================
                const Text(
                  'CÁC CÂU LẠC BỘ TẠI FPT SCHOOL',
                  style: TextStyle(
                    fontFamily: 'Asap',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F4C5C),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                if (otherClubs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Không có câu lạc bộ nào khác.',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ...otherClubs.map(
                    (club) => ClubCard(club: club, isJoined: false),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: Color(0xFFFF5722)),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đã xảy ra lỗi khi tải danh sách CLB 😢',
                style: TextStyle(
                  fontFamily: 'Asap',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString().replaceAll('Exception: ', ''),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(clubProvider.notifier)
                    .fetchStudentClubs(studentId, isSilent: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
