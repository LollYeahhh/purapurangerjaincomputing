import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/checksheet_item_model.dart';

class ChecksheetService {
  /// Simpan data inventaris (Tool Box)
  static Future<Map<String, dynamic>> simpanDataInventaris({
    required int laporanId,
    required String token,
    required String namaSheet,
    required List<ChecksheetItemModel> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/laporan/$laporanId/simpan-data-inventaris',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'nama_sheet': namaSheet,
          'data': items.map((item) => item.toJson()).toList(),
        }),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonData['message'] ?? 'Data berhasil disimpan',
        };
      } else if (response.statusCode == 403) {
        throw Exception(jsonData['message'] ?? 'Anda tidak memiliki izin');
      } else if (response.statusCode == 422) {
        throw Exception(jsonData['message'] ?? 'Data tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated');
      } else {
        throw Exception('Gagal menyimpan data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// ✅ SIMULASI untuk development (dummy)
  static Future<Map<String, dynamic>> simpanDataInventarisSimulasi({
    required int laporanId,
    required String token,
    required String namaSheet,
    required List<ChecksheetItemModel> items,
  }) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // Validasi
    if (namaSheet.isEmpty) {
      throw Exception('Nama sheet tidak boleh kosong');
    }

    if (items.isEmpty) {
      throw Exception('Data item tidak boleh kosong');
    }

    // Simulasi sukses
    return {
      'success': true,
      'message': "Data '$namaSheet' telah berhasil disimpan.",
    };
  }
}
