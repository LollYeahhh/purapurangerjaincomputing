// lib/services/checksheet_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/checksheet_item_model.dart';
import '../models/checksheet_komponen_model.dart';

class ChecksheetService {
  /// ✅ Simpan data inventaris (Tool Box, Tool Kit, dll)
  static Future<Map<String, dynamic>> simpanDataInventaris({
    required int laporanId,
    required String token,
    required String namaSheet,
    required List<ChecksheetItemModel> items,
  }) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.apiVersion}/laporan/$laporanId/simpan-data-inventaris',
      );

      // ✅ Logging request (untuk debugging)
      print('🚀 POST: $url');
      print('📦 Sheet: $namaSheet');
      print('📦 Items: ${items.length}');

      final body = {
        'nama_sheet': namaSheet,
        'data': items.map((item) => item.toJson()).toList(),
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      // ✅ Parse response
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      // ✅ Handle berdasarkan status code
      switch (response.statusCode) {
        case 200:
          // ✅ Sukses
          return {
            'success': true,
            'message':
                jsonData['message'] ??
                "Data '$namaSheet' telah berhasil disimpan.",
          };

        case 401:
          // ❌ Unauthorized (Token expired/invalid)
          throw Exception(
            jsonData['message'] ??
                'Sesi Anda telah berakhir. Silakan login kembali.',
          );

        case 403:
          // ❌ Forbidden (Tidak punya akses)
          throw Exception(
            jsonData['message'] ??
                'Anda tidak memiliki izin untuk mengubah laporan ini.',
          );

        case 422:
          // ❌ Validation Error
          final errors = jsonData['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            // Ambil semua error messages
            final errorList = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                errorList.addAll(value.map((e) => e.toString()));
              } else {
                errorList.add(value.toString());
              }
            });
            throw Exception(errorList.join('\n'));
          } else {
            throw Exception(
              jsonData['message'] ?? 'Data yang diberikan tidak valid.',
            );
          }

        case 404:
          // ❌ Not Found
          throw Exception('Laporan tidak ditemukan.');

        case 500:
          // ❌ Server Error
          throw Exception(
            'Terjadi kesalahan pada server. Silakan coba lagi nanti.',
          );

        default:
          // ❌ Error lainnya
          throw Exception(
            jsonData['message'] ?? 'Terjadi kesalahan (${response.statusCode})',
          );
      }
    } on http.ClientException catch (e) {
      // ❌ Network error
      print('❌ Network Error: $e');
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on FormatException catch (e) {
      // ❌ JSON parsing error
      print('❌ Parse Error: $e');
      throw Exception('Terjadi kesalahan saat memproses data dari server.');
    } catch (e) {
      // ❌ Error lainnya
      print('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow; // Rethrow jika sudah Exception
      }
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// ✅ Simpan data komponen (Mekanik, Genset, dll)
  static Future<Map<String, dynamic>> simpanDataKomponen({
    required int laporanId,
    required String token,
    required String namaSheet,
    required List<ChecksheetKomponenModel> items,
  }) async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.apiVersion}/laporan/$laporanId/simpan-data-komponen',
      );

      // ✅ Logging request (untuk debugging)
      print('🚀 POST: $url');
      print('📦 Sheet: $namaSheet');
      print('📦 Items: ${items.length}');

      final body = {
        'nama_sheet': namaSheet,
        'data': items.map((item) => item.toJson()).toList(),
      };

      print('📦 Body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      // ✅ Parse response
      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      // ✅ Handle berdasarkan status code
      switch (response.statusCode) {
        case 200:
          // ✅ Sukses
          return {
            'success': true,
            'message':
                jsonData['message'] ??
                "Data '$namaSheet' telah berhasil disimpan.",
          };

        case 401:
          // ❌ Unauthorized (Token expired/invalid)
          throw Exception(
            jsonData['message'] ??
                'Sesi Anda telah berakhir. Silakan login kembali.',
          );

        case 403:
          // ❌ Forbidden (Tidak punya akses)
          throw Exception(
            jsonData['message'] ??
                'Anda tidak memiliki izin untuk mengubah laporan ini.',
          );

        case 422:
          // ❌ Validation Error
          final errors = jsonData['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            // Ambil semua error messages
            final errorList = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                errorList.addAll(value.map((e) => e.toString()));
              } else {
                errorList.add(value.toString());
              }
            });
            throw Exception(errorList.join('\n'));
          } else {
            throw Exception(
              jsonData['message'] ?? 'Data yang diberikan tidak valid.',
            );
          }

        case 404:
          // ❌ Not Found
          throw Exception('Laporan tidak ditemukan.');

        case 500:
          // ❌ Server Error
          throw Exception(
            'Terjadi kesalahan pada server. Silakan coba lagi nanti.',
          );

        default:
          // ❌ Error lainnya
          throw Exception(
            jsonData['message'] ?? 'Terjadi kesalahan (${response.statusCode})',
          );
      }
    } on http.ClientException catch (e) {
      // ❌ Network error
      print('❌ Network Error: $e');
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on FormatException catch (e) {
      // ❌ JSON parsing error
      print('❌ Parse Error: $e');
      throw Exception('Terjadi kesalahan saat memproses data dari server.');
    } catch (e) {
      // ❌ Error lainnya
      print('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow; // Rethrow jika sudah Exception
      }
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// ✅ SIMULASI untuk development/testing - Inventaris (Tool Box, Tool Kit)
  static Future<Map<String, dynamic>> simpanDataInventarisSimulasi({
    required int laporanId,
    required String token,
    required String namaSheet,
    required List<ChecksheetItemModel> items,
  }) async {
    print('🧪 SIMULASI MODE - Inventaris');
    print('📦 Laporan ID: $laporanId');
    print('📦 Sheet: $namaSheet');
    print('📦 Items: ${items.length}');

    // ✅ Simulasi delay network
    await Future.delayed(const Duration(seconds: 2));

    // ✅ Validasi
    if (namaSheet.isEmpty) {
      throw Exception('Nama sheet tidak boleh kosong.');
    }

    if (items.isEmpty) {
      throw Exception('Data item tidak boleh kosong.');
    }

    // ✅ Validasi setiap item harus ada hasil_input
    final itemsWithoutInput = items.where((item) => item.hasilInput.isEmpty);
    if (itemsWithoutInput.isNotEmpty) {
      throw Exception('Semua item harus diisi terlebih dahulu.');
    }

    // ✅ Simulasi sukses
    return {
      'success': true,
      'message': "Data '$namaSheet' telah berhasil disimpan.",
    };

    // ✅ Uncomment untuk simulasi error tertentu:
    // throw Exception('Anda tidak memiliki izin untuk mengubah laporan ini.'); // 403
    // throw Exception('Data yang diberikan tidak valid.'); // 422
    // throw Exception('Sesi Anda telah berakhir. Silakan login kembali.'); // 401
  }

  /// ✅ SIMULASI untuk development/testing - Komponen (Mekanik, Genset)
  static Future<Map<String, dynamic>> simpanDataKomponenSimulasi({
    required int laporanId,
    required String token,
    required String namaSheet,
    required List<ChecksheetKomponenModel> items,
  }) async {
    print('🧪 SIMULASI MODE - Komponen');
    print('📦 Laporan ID: $laporanId');
    print('📦 Sheet: $namaSheet');
    print('📦 Items: ${items.length}');

    // ✅ Simulasi delay network
    await Future.delayed(const Duration(seconds: 2));

    // ✅ Validasi
    if (namaSheet.isEmpty) {
      throw Exception('Nama sheet tidak boleh kosong.');
    }

    if (items.isEmpty) {
      throw Exception('Data item tidak boleh kosong.');
    }

    // ✅ Validasi setiap item harus ada standar dan hasil_input
    final itemsWithoutInput = items.where(
      (item) => item.hasilInput.isEmpty || item.standar.isEmpty,
    );
    if (itemsWithoutInput.isNotEmpty) {
      throw Exception('Semua item harus diisi terlebih dahulu.');
    }

    // ✅ Simulasi sukses
    return {
      'success': true,
      'message': "Data '$namaSheet' telah berhasil disimpan.",
    };

    // ✅ Uncomment untuk simulasi error tertentu:
    // throw Exception('Anda tidak memiliki izin untuk mengubah laporan ini.'); // 403
    // throw Exception('Data yang diberikan tidak valid.'); // 422
    // throw Exception('Sesi Anda telah berakhir. Silakan login kembali.'); // 401
  }
}
