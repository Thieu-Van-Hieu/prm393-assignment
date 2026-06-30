import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/api/auth_api.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/request/forgot_password_request.dart';
import 'package:my_fschool_frontend/model/request/login_request.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_bottom_sheet.dart';
import 'package:my_fschool_frontend/widget/input/app_text_field.dart';
import 'package:my_fschool_frontend/widget/login/footer.dart';
import 'package:my_fschool_frontend/widget/login/forgot_password_sheet_content.dart';
import 'package:my_fschool_frontend/widget/login/header.dart';
import 'package:my_fschool_frontend/widget/notification/app_snackbar.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Khởi tạo các Hooks quản lý tập trung ở đầu màn hình
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final dialogFormKey = useMemoized(
      () => GlobalKey<FormState>(),
    ); // FormKey riêng cho Dialog
    //TODO: Thiết lập phone, password mặc định khi debug để test nhanh
    final phoneController = useTextEditingController(text: "0395069078");
    final passwordController = useTextEditingController(text: "66771508");
    final forgotPhoneController = useTextEditingController();
    final isLoading = useState(false);

    final authApi = useMemoized(() => AuthApi());

    // 2. Hàm xử lý logic Đăng nhập chính
    void handleLogin() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;

        // Gọi API và hứng trọn gói ApiResponse
        final result = await authApi.login(
          loginRequest: LoginRequest(
            phoneNumber: phoneController.text.trim(),
            password: passwordController.text,
          ),
        );

        isLoading.value = false;

        // 💥 KIỂM TRA LỖI PHÁT MỘT
        if (result.hasError) {
          if (context.mounted) {
            AppSnackbar.showOpacityError(context, result.errorMessage!);
          }
          return; // Dừng luồng xử lý
        }

        // --- ĐOẠN DƯỚI NÀY LÀ KHI API ĐÃ THÀNH CÔNG ---
        final response = result.data;
        if (response != null && response.statusCode == 200) {
          final List<String>? cookies = response.headers['set-cookie'];
          String? jsessionId;

          if (cookies != null && cookies.isNotEmpty) {
            for (var cookie in cookies) {
              if (cookie.contains('JSESSIONID=')) {
                jsessionId = cookie.split(';')[0].split('=')[1];
                break;
              }
            }
          }

          if (jsessionId != null) {
            await SessionManager.saveSession(jsessionId);
            debugPrint("Đã găm JSESSIONID thành công: $jsessionId");
          }

          if (context.mounted) {
            AppSnackbar.showSuccess(context, "Đăng nhập thành công!");
            context.go('/dashboard');
          }
        }
      }
    }

    // 3. Hàm xử lý Quên mật khẩu
    void handleForgotPassword() async {
      if (dialogFormKey.currentState!.validate()) {
        final result = await authApi.forgotPassword(
          forgotPasswordRequest: ForgotPasswordRequest(
            phoneNumber: forgotPhoneController.text.trim(),
          ),
        );

        if (!context.mounted) return;

        if (result.hasError) {
          AppSnackbar.showOpacityError(context, result.errorMessage!);
          return;
        }

        final response = result.data;
        String message =
            response?.data['message'] ?? "Mật khẩu mới đã được gửi qua SMS!";

        AppSnackbar.showSuccess(context, message);
        Navigator.of(context).pop(true);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          // Bấm ra ngoài tự ẩn bàn phím
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints
                        .maxHeight, // Ép chiều cao tối thiểu bằng màn hình để đẩy chân trang xuống đáy
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            LoginHeader(),
                            const SizedBox(height: 28),

                            // 📱 Ô NHẬP SỐ ĐIỆN THOẠI CHÍNH (Đã thêm prefixIcon)
                            AppTextField(
                              label: 'Số điện thoại',
                              hintText: 'Nhập số điện thoại',
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: const Icon(
                                Icons.phone_android_outlined,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Vui lòng không để trống số điện thoại';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // 🔒 Ô NHẬP MẬT KHẨU CHÍNH (Đã thêm prefixIcon)
                            AppTextField(
                              label: 'Mật khẩu',
                              hintText: '••••••••••••',
                              controller: passwordController,
                              isPassword: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 40),

                            // NÚT ĐĂNG NHẬP CHÍNH
                            AppButton(
                              text: 'Đăng nhập',
                              type: AppButtonType.primary,
                              size: AppButtonSize.big,
                              isLoading: isLoading.value,
                              onPressed: handleLogin,
                            ),

                            const SizedBox(height: 16),

                            // NÚT QUÊN MẬT KHẨU
                            TextButton(
                              onPressed: () {
                                forgotPhoneController.text =
                                    phoneController.text;

                                AppBottomSheet.show(
                                  context: context,
                                  title: "Quên mật khẩu",
                                  content: ForgotPasswordSheetContent(
                                    forgotPhoneController:
                                        forgotPhoneController,
                                    handleForgotPassword: handleForgotPassword,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textLink,
                              ),
                              child: const Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Asap',
                                ),
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 24),

                            // 📑 CỤM VERSION, COPYRIGHT & TÁC GIẢ (Gộp chung Column)
                            LoginFooter(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
