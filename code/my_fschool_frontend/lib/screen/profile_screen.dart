import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/api/auth_api.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/request/change_password_request.dart';
import 'package:my_fschool_frontend/notifier/user_profile_notifier.dart';
import 'package:my_fschool_frontend/provider/workspace_index_provider.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_bottom_sheet.dart';
import 'package:my_fschool_frontend/widget/notification/app_snackbar.dart';
import 'package:my_fschool_frontend/widget/profile/change_password_sheet_content.dart';
import 'package:my_fschool_frontend/widget/profile/info_sheet_content.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authApi = useMemoized(() => AuthApi());
    final isChangingPassword = useState(false);

    final userProfileAsync = ref.watch(userProfileProvider);

    final selectedChildIndex = ref.watch(selectedWorkspaceIndexProvider);

    // Tự động ra lệnh làm tươi dữ liệu ngầm khi đặt chân vào màn hình Profile
    useEffect(() {
      Future.microtask(() {
        if (userProfileAsync.hasValue && userProfileAsync.value != null) {
          ref
              .read(userProfileProvider.notifier)
              .fetchUserProfile(isSilent: true);
        } else {
          ref
              .read(userProfileProvider.notifier)
              .fetchUserProfile(isSilent: false);
        }
      });
      return null;
    }, []);

    // Hàm xử lý Đăng xuất
    void handleLogout() async {
      await SessionManager.clear();

      ref.read(selectedWorkspaceIndexProvider.notifier).state = 0;

      if (context.mounted) {
        context.go('/login');
      }
    }

    return userProfileAsync.when(
      skipLoadingOnReload: true,

      loading: () => const Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: CircularProgressIndicator(color: AppColors.orangeFPT),
          ),
        ),
      ),

      error: (err, stack) => Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
            child: Text(
              err.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontFamily: 'Asap', fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),

      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(color: AppColors.orangeFPT),
              ),
            ),
          );
        }

        return SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 📦 KHỐI MENU CHỨA CÁC TÙY CHỌN
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Hàng 1: Thông tin cá nhân
                        ListTile(
                          onTap: () {
                            AppBottomSheet.show(
                              context: context,
                              title: 'Thông tin cá nhân',
                              content: InfoSheetContent(
                                profile: profile,
                                // 🎯 ĐẬP DỮ LIỆU ĐÃ ĐƯỢC CHUẨN HÓA AN TOÀN VÀO ĐÂY
                                workspaceIndex: selectedChildIndex,
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          title: const Text(
                            'Thông tin cá nhân',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFamily: 'Asap',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),

                        // Hàng 2: Đổi mật khẩu
                        ListTile(
                          onTap: () {
                            AppBottomSheet.show(
                              context: context,
                              title: 'Đổi mật khẩu',
                              content: ChangePasswordSheetContent(
                                isLoading: isChangingPassword.value,
                                onSubmitted: (oldPass, newPass) async {
                                  isChangingPassword.value = true;
                                  final result = await authApi.changePassword(
                                    ChangePasswordRequest(
                                      oldPassword: oldPass.trim(),
                                      newPassword: newPass.trim(),
                                    ),
                                  );
                                  isChangingPassword.value = false;

                                  if (!context.mounted) return;

                                  if (result.hasError) {
                                    AppSnackbar.showOpacityError(
                                      context,
                                      result.errorMessage!,
                                    );
                                    return;
                                  }

                                  final response = result.data;
                                  String successMsg =
                                      response?.data['message'] ??
                                      "Đổi mật khẩu thành công!";
                                  AppSnackbar.showSuccess(context, successMsg);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          title: const Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFamily: 'Asap',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 🛑 NÚT ĐĂNG XUẤT TONAL STYLE
                  AppButton(
                    text: 'Đăng xuất',
                    size: AppButtonSize.medium,
                    type: AppButtonType.danger,
                    style: AppButtonStyle.tonal,
                    onPressed: handleLogout,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
