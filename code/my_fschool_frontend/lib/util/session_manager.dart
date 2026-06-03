import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static const _storage = FlutterSecureStorage();

  // Đọc Key lưu trữ từ file .env, nếu lỗi thì fallback về chữ mặc định 'JSESSIONID'
  static String get _sessionKey => dotenv.env['SESSION_KEY'] ?? 'JSESSIONID';

  // 1. Lưu Session ID khi đăng nhập thành công
  static Future<void> saveSession(String jsessionId) async {
    await _storage.write(key: _sessionKey, value: jsessionId);
  }

  // 2. Lấy Session ID ra để xài
  static Future<String?> getSession() async {
    return await _storage.read(key: _sessionKey);
  }

  // 3. Xóa Session khi đăng xuất
  static Future<void> clear() async {
    await _storage.delete(key: _sessionKey);
  }
}
