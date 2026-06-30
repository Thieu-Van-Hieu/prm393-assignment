import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/api/application_api.dart';
import 'package:my_fschool_frontend/notifier/application_notifier.dart';
import 'package:my_fschool_frontend/provider/workspace_index_provider.dart';
import 'package:my_fschool_frontend/widget/application/application_card.dart';
import 'package:my_fschool_frontend/widget/application/create_application_sheet_content.dart';
import 'package:my_fschool_frontend/widget/input/app_bottom_sheet.dart';

class ApplicationScreen extends HookConsumerWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe trạng thái bất đồng bộ từ AsyncNotifierProvider của đơn từ
    final applicationsAsync = ref.watch(applicationProvider);

    // Kích hoạt gọi API ngay khi màn hình khởi tạo lần đầu
    useEffect(() {
      Future.microtask(
        () => ref.read(applicationProvider.notifier).fetchParentApplications(),
      );
      return null;
    }, []);

    return Stack(
      children: [
        // 🧱 Khối 1: Hiển thị danh sách đơn từ dạng cuộn dọc
        Column(
          children: [
            applicationsAsync.when(
              data: (applicationList) {
                if (applicationList.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        'Chưa có đơn từ nào được gửi.',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 90),
                    // 🎯 Để khoảng cách bottom thoáng, không bị nút đè lên card cuối
                    itemCount: applicationList.length,
                    itemBuilder: (context, index) {
                      return ApplicationCard(
                        application: applicationList[index],
                      );
                    },
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
                        'Đã xảy ra lỗi khi tải danh sách đơn từ 😢',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // 🎯 Khối 2: Nút FloatingActionButton đặt cố định góc dưới bên phải màn hình
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            onPressed: () => _showCreateApplicationModal(context, ref),
            backgroundColor: const Color(0xFFFF9800),
            // Đồng bộ tông cam chủ đạo hệ thống
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
            label: const Text(
              'Tạo đơn',
              style: TextStyle(
                fontFamily: 'Asap',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 🧱 Hàm helper mở Custom Bottom Sheet để phụ huynh điền Form tạo đơn
  void _showCreateApplicationModal(BuildContext context, WidgetRef ref) {
    // Luôn lưu lại context của màn hình lớn trước khi vào hàm hiển thị sheet
    final rootContext = context;

    AppBottomSheet.show(
      context: context,
      title: 'Tạo đơn xin nghỉ/miễn giảm mới',
      content: CreateApplicationSheetContent(
        onSubmit:
            ({required typeCode, required reason, fromDate, toDate}) async {
              try {
                final activeWorkspace = ref.read(activeWorkspaceProvider);
                final studentId = activeWorkspace?.profile.id;

                if (studentId == null) {
                  if (rootContext.mounted) {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Không tìm thấy thông tin học sinh hiện tại!',
                        ),
                      ),
                    );
                  }
                  return;
                }

                // 1. Kích hoạt call API tạo đơn
                final applicationApi = ApplicationApi();
                final response = await applicationApi.createApplication(
                  studentId: studentId,
                  applicationType: typeCode,
                  reason: reason,
                  fromDate: fromDate,
                  toDate: toDate,
                );

                // Kiểm tra xem màn hình lớn có còn tồn tại không
                if (!rootContext.mounted) return;

                if (response.isSuccess) {
                  // 2. Hiển thị thông báo thành công lên màn hình chính
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    const SnackBar(
                      content: Text('Nộp đơn xin phê duyệt thành công! 🎉'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 3. Đóng Bottom Sheet một cách an toàn bằng chính rootContext
                  Navigator.of(rootContext).pop();

                  // 4. Cập nhật lại danh sách data
                  await ref
                      .read(applicationProvider.notifier)
                      .fetchParentApplications();
                } else {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gửi đơn thất bại: ${response.errorMessage}',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (rootContext.mounted) {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(content: Text('Đã xảy ra lỗi hệ thống: $e')),
                  );
                }
              }
            },
      ),
    );
  }
}
