import 'dart:async';
import '../models/inventory_item.dart';
import '../models/component_item.dart';
import '../models/log_entry.dart';

/// DummyApiService - Layanan API dummy yang meniru kontrak API sebenarnya.
class DummyApiService {
  // Data dummy untuk Tool Box (Inventaris 1)
  static final List<InventoryItem> _toolBoxItems = [
    InventoryItem(name: "Palu", requiredCount: 1),
    InventoryItem(name: "Obeng (+)", requiredCount: 1),
    InventoryItem(name: "Obeng (-)", requiredCount: 1),
    InventoryItem(name: "Tang", requiredCount: 1),
    InventoryItem(name: "Kunci Inggris", requiredCount: 1),
    InventoryItem(name: "Baut Cadangan", requiredCount: 4),
  ];

  // Data dummy untuk Tool Kit (Inventaris 2)
  static final List<InventoryItem> _toolKitItems = [
    InventoryItem(name: "Multimeter", requiredCount: 1),
    InventoryItem(name: "Senter", requiredCount: 1),
    InventoryItem(name: "Kunci Pas Set", requiredCount: 1),
    InventoryItem(name: "Pita Isolasi", requiredCount: 2),
    InventoryItem(name: "Kunci L Set", requiredCount: 1),
    InventoryItem(name: "Sekring Cadangan", requiredCount: 3),
  ];

  // Daftar nama komponen mekanik (Form Komponen Mekanik)
  static final List<String> _mechanicComponentNames = [
    "Kondisi Baut",
    "Pelumas",
    "Kondisi Roda",
    "Rem",
    "Bogie",
  ];

  // Daftar nama komponen elektrik (Form Komponen Electric)
  static final List<String> _electricComponentNames = [
    "Lampu Depan",
    "Baterai",
    "Klakson",
    "Kabel",
    "Sekering",
  ];

  // Daftar nama item matriks mekanik (Form Mekanik 2)
  static final List<String> _mechanicMatrixItemNames = [
    "Pintu",
    "Jendela",
    "Rem Udara",
    "Sambungan",
    "Suspensi",
  ];

  // Daftar nama item matriks elektrik (Form Electric 2)
  static final List<String> _electricMatrixItemNames = [
    "Lampu Interior",
    "Penyejuk Udara",
    "Indikator",
    "Panel Kontrol",
    "Motor Listrik",
  ];

  /// Fetch list inventaris Tool Box (Checksheet Inventaris 1)
  static Future<List<InventoryItem>> fetchToolBoxItems() async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));
    return _toolBoxItems;
  }

  /// Fetch list inventaris Tool Kit (Checksheet Inventaris 2)
  static Future<List<InventoryItem>> fetchToolKitItems() async {
    await Future.delayed(const Duration(seconds: 1));
    return _toolKitItems;
  }

  /// Fetch list komponen Mekanik (Form Komponen Mekanik)
  static Future<List<ComponentItem>> fetchMechanicComponents() async {
    await Future.delayed(const Duration(seconds: 1));
    // Konversi nama komponen menjadi list ComponentItem dengan status awal null
    return _mechanicComponentNames
        .map((name) => ComponentItem(name: name))
        .toList();
  }

  /// Fetch list komponen Electric (Form Komponen Electric)
  static Future<List<ComponentItem>> fetchElectricComponents() async {
    await Future.delayed(const Duration(seconds: 1));
    return _electricComponentNames
        .map((name) => ComponentItem(name: name))
        .toList();
  }

  /// Fetch list item matriks Mekanik (Form Mekanik 2) berdasarkan gerbong & fase
  static Future<List<ComponentItem>> fetchMechanicMatrixItems(
    int car,
    String phase,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    // Tambahkan keterangan gerbong & fase pada nama item untuk membedakan
    return _mechanicMatrixItemNames
        .map((name) => ComponentItem(name: "$name - Gerbong $car ($phase)"))
        .toList();
  }

  /// Fetch list item matriks Electric (Form Electric 2) berdasarkan gerbong & fase
  static Future<List<ComponentItem>> fetchElectricMatrixItems(
    int car,
    String phase,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return _electricMatrixItemNames
        .map((name) => ComponentItem(name: "$name - Gerbong $car ($phase)"))
        .toList();
  }

  // Data dummy untuk log gangguan awal
  static final List<LogEntry> _logEntries = [
    LogEntry(
      id: 1,
      description: "Kerusakan AC di gerbong 3",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LogEntry(
      id: 2,
      description: "Lampu kabin gerbong 5 padam",
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  /// Fetch list log gangguan
  static Future<List<LogEntry>> fetchLogs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Kembalikan copy untuk memastikan _logEntries asli tidak terpengaruh langsung
    return List<LogEntry>.from(_logEntries);
  }

  /// Tambah log gangguan baru
  static Future<LogEntry> addLog(String description) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newEntry = LogEntry(
      id: _logEntries.length + 1,
      description: description,
      date: DateTime.now(),
    );
    _logEntries.add(newEntry);
    return newEntry;
  }
}
