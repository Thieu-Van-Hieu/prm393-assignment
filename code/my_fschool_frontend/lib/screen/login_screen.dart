import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/api/auth_api.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/request/forgot_password_request.dart';
import 'package:my_fschool_frontend/model/request/login_request.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';
import 'package:my_fschool_frontend/widget/button/app_button.dart';
import 'package:my_fschool_frontend/widget/input/app_dialog.dart';
import 'package:my_fschool_frontend/widget/input/app_text_field.dart';
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
    final phoneController = useTextEditingController(text: "0395069078");
    final passwordController = useTextEditingController(text: "Hieu123.");
    final forgotPhoneController = useTextEditingController();
    final isLoading = useState(false);

    final authApi = useMemoized(() => AuthApi());

    // 2. Hàm xử lý logic Đăng nhập chính
    void handleLogin() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        try {
          final response = await authApi.login(
            loginRequest: LoginRequest(
              phoneNumber: phoneController.text.trim(),
              password: passwordController.text,
            ),
          );

          if (response != null && response.statusCode == 200) {
            final List<String>? cookies = response.headers['set-cookie'];
            String? jsessionId;

            if (cookies != null && cookies.isNotEmpty) {
              for (var cookie in cookies) {
                if (cookie.contains('JSESSIONID=')) {
                  // Bóc tách lấy đúng chuỗi mã hash: "CF2F501D2EF18D1BC2FCD6..."
                  jsessionId = cookie.split(';')[0].split('=')[1];
                  break;
                }
              }
            }

            // 2. Nếu tìm thấy Session ID thì găm thẳng vào Secure Storage
            if (jsessionId != null) {
              await SessionManager.saveSession(jsessionId);
              debugPrint("Đã găm JSESSIONID thành công: $jsessionId");
            }

            if (context.mounted) {
              debugPrint("Dăng nhập thành công, chuyển hướng tới Dashboard");
              AppSnackbar.showSuccess(context, "Đăng nhập thành công!");
              context.go('/dashboard');
            }
          }
        } catch (errorMessage) {
          if (context.mounted) {
            // Bắn snackbar lỗi màu đỏ từ thông điệp Spring Boot trả về
            AppSnackbar.showOpacityError(context, errorMessage.toString());
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    void handleForgotPassword() async {
      if (dialogFormKey.currentState!.validate()) {
        final response = await authApi.forgotPassword(
          forgotPasswordRequest: ForgotPasswordRequest(
            phoneNumber: forgotPhoneController.text.trim(),
          ),
        );
        String message;
        if (response != null && response.statusCode == 200) {
          message =
              response.data['message'] ?? "Mật khẩu mới đã được gửi qua SMS!";
        } else {
          message = "Có lỗi xảy ra. Vui lòng thử lại sau.";
        }
        debugPrint(
          "Kích hoạt gửi SMS Gateway tới: ${forgotPhoneController.text}",
        );
        if (!context.mounted) return;
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // LOGO FPT SCHOOL
                  Image.asset(
                    'assets/fpt_logo.png',
                    height: 72,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.school,
                        size: 48,
                        color: AppColors.orangeFPT,
                      );
                    },
                  ),
                  const Text(
                    'FPT School',
                    style: TextStyle(
                      color: AppColors.orangeFPT,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Asap',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CỤM CHỮ TIÊU ĐỀ ĐĂNG NHẬP
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Asap',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Chào mừng quý phụ huynh',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            fontFamily: 'Asap',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Ô NHẬP SỐ ĐIỆN THOẠI CHÍNH
                  AppTextField(
                    label: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại phụ huynh',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng không để trống số điện thoại';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Ô NHẬP MẬT KHẨU CHÍNH
                  AppTextField(
                    label: 'Mật khẩu',
                    hintText: '••••••••••••',
                    controller: passwordController,
                    isPassword: true,
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
                      // ĐỒNG BỘ: Gán mặc định số điện thoại từ ô chính sang ô trong Dialog
                      forgotPhoneController.text = phoneController.text;

                      // Gọi hiển thị Dialog Quên mật khẩu
                      AppDialog.show(
                        context: context,
                        title: 'Quên mật khẩu',
                        // Bọc Form con ở đây để validator của dialog hoạt động
                        content: Form(
                          key: dialogFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mật khẩu mới sẽ được gửi qua tới số điện thoại này.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 18,
                                  fontFamily: 'Asap',
                                ),
                              ),
                              const SizedBox(height: 20),
                              AppTextField(
                                label: 'Số điện thoại phụ huynh',
                                hintText: 'Nhập số điện thoại để nhận mã',
                                controller: forgotPhoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng không để trống số điện thoại';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          AppButton(
                            text: 'Gửi OTP',
                            type: AppButtonType.primary,
                            size: AppButtonSize.small,
                            width: 100,
                            onPressed: handleForgotPassword,
                          ),
                        ],
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textLink,
                    ),
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(fontSize: 18, fontFamily: 'Asap'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
