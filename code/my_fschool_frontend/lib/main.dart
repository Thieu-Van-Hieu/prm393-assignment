import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_fschool_frontend/config/app_dio.dart';
import 'package:my_fschool_frontend/route/app_router.dart';
import 'package:nsd/nsd.dart';

void discoverSpringBootService() async {
  // Bắt đầu quét dịch vụ dạng _http._tcp
  final discovery = await startDiscovery('_http._tcp');

  discovery.addListener(() {
    debugPrint("Số lượng services: ${discovery.services.length}");
    for (final service in discovery.services) {
      debugPrint("Service: $service");
      // Lọc theo đúng tên đã đặt ở Spring Boot
      if (service.name == AppDio.backendService) {
        final String? host = service.host; // Đây chính là IP của laptop
        final int? port =
            service.port; // Đây là Port của Spring Boot (ví dụ: 8080)

        debugPrint('Tìm thấy Spring Boot tại: http://$host:$port');
        if (host != null && port != null) {
          AppDio.updateBaseUrl(host, port);
        }

        // Sau khi tìm thấy, nên tắt discovery để tiết kiệm pin
        stopDiscovery(discovery);
        break;
      }
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load file cấu hình .env lên bộ nhớ
  discoverSpringBootService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FSchool Parent',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
