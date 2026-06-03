import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/layout/main_layout.dart';
import 'package:my_fschool_frontend/route/app_router_config.dart';
import 'package:my_fschool_frontend/screen/login_screen.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // 1. Màn hình Đăng nhập (Nằm ngoài Layout chung)
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),

      // 2. TỰ ĐỘNG SINH ROUTE CHO CÁC TRANG CÓ LAYOUT (HEADER + NAVBAR)
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(
            child: child,
          ); // Bọc vỏ bọc Header + Footer ra ngoài
        },
        // 💥 Dùng phép thuật duyệt Map để sinh tự động danh sách GoRoute
        routes: AppRouteMeta.appRouterConfig.entries.map((entry) {
          final String path = entry.key;
          final AppRouteMeta meta = entry.value;

          return GoRoute(
            path: path,
            builder:
                meta.builder, // Gọi đúng hàm builder đã khai báo ở file config
          );
        }).toList(),
      ),
    ],

    // Luồng chặn bọc bảo mật giữ nguyên của phen
    redirect: (context, state) async {
      final loggedIn = await SessionManager.getSession() != null;

      final bool loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/forgot-password';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/dashboard';
      return null;
    },
  );
}
