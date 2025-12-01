import 'package:flutter/foundation.dart';
import '../models/log_entry.dart';
import 'dummy_api_service.dart';

/// LogProvider - Provider untuk state Log Gangguan (list log dan operasi tambah)
class LogProvider extends ChangeNotifier {
  bool _loading = false;
  List<LogEntry> _logs = [];

  bool get loading => _loading;
  List<LogEntry> get logs => _logs;

  LogProvider() {
    // Langsung fetch log saat provider diinisialisasi
    fetchLogs();
  }

  /// Ambil semua log gangguan (dari DummyApiService)
  Future<void> fetchLogs() async {
    _loading = true;
    notifyListeners();
    final data = await DummyApiService.fetchLogs();
    _logs = data;
    _loading = false;
    notifyListeners();
  }

  /// Tambah log gangguan baru (memanggil DummyApiService.addLog)
  Future<void> addLog(String description) async {
    // Tambahkan ke dummy API dan ke state list
    final newEntry = await DummyApiService.addLog(description);
    _logs.add(newEntry);
    notifyListeners();
  }
}
