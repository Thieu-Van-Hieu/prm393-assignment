import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/extension/context_extension.dart';
import 'package:my_fschool_frontend/layout/navbar/app_navbar.dart';
import 'package:my_fschool_frontend/route/app_router_config.dart';
import 'package:my_fschool_frontend/util/session_manager.dart';

class MainLayout extends HookWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final AppRouteMeta meta = AppRouteMeta.getMetaForLocation(location);

    useEffect(() {
      void checkSession() async {
        final hasSession = await SessionManager.getSession() != null;
        if (!hasSession && context.mounted) {
          context.go('/login');
        }
      }

      checkSession();
      return null;
    }, [location]);

    return Scaffold(
      backgroundColor: AppColors.background,

      // A. HEADER TỰ ĐỘNG ĂN THEO CẤU HÌNH META
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: meta.hasBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () => context.safePop,
              )
            : null,
        // Ăn theo biến title trong class Meta
        title: Text(
          meta.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Asap',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.2),
            height: 1,
          ),
        ),
      ),

      // B. BODY ĐỘNG
      body: child,

      // C. NAVBAR ĐÁY TỰ ĐỘNG ẨN/HIỆN
      // Nếu tabIndex == -1 (Trang con) -> Tự ẩn Navbar đáy bằng cách truyền null
      bottomNavigationBar: meta.tabIndex == -1
          ? null
          : AppNavbar(
              currentIndex: meta.tabIndex,
              onTap: (index) {
                if (index == meta.tabIndex) return;
                context.go(AppNavbar.navItems()[index].key);
              },
            ),
    );
  }
}
