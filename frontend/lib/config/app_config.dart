/// Configuration untuk aplikasi
/// Mengatur mode simulasi dan base URL API
class AppConfig {
  // 🔧 MODE SIMULASI
  // true = Gunakan mock data (untuk development)
  // false = Gunakan API real (untuk production)
  static const bool isSimulationMode = true;

  // 🔗 BASE URL API
  // Ganti dengan URL backend yang sebenarnya saat production
  static const String baseUrl = 'https://api.kai.com/api';

  // ⏱️ TIMEOUT DURATION
  static const Duration apiTimeout = Duration(seconds: 10);

  // 📱 APP INFO
  static const String appName = 'KAI Checksheet';
  static const String appVersion = '1.0.0';

  // 🎨 UI CONFIG
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration loadingDelay = Duration(milliseconds: 500);

  /// Mendapatkan header untuk API request
  static Map<String, String> getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Log helper untuk debugging
  static void log(String message, {String tag = 'AppConfig'}) {
    if (isSimulationMode) {
      print('[$tag] $message');
    }
  }
}
