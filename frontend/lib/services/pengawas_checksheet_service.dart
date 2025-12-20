import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checksheet_review_model.dart';
import '../config/app_config.dart';
import '../utils/mock_checksheet_data.dart';

/// Service khusus untuk fitur Pengawas
/// Menangani API calls untuk review checksheet
class PengawasChecksheetService {
  /// GET /api/laporan/{id}
  /// Mengambil detail laporan untuk review
  static Future<ChecksheetReviewModel> getLaporanDetail(
    String token,
    int laporanId,
  ) async {
    // ✅ MODE SIMULASI: Langsung return mock data
    if (AppConfig.isSimulationMode) {
      AppConfig.log(
        '🔄 Mode Simulasi: Loading mock data untuk laporan $laporanId',
      );
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulasi network delay
      return MockChecksheetData.getMockInventaris(laporanId);
    }

    // 🌐 MODE PRODUCTION: Hit API real
    try {
      AppConfig.log('🌐 Fetching laporan detail from API: $laporanId');

      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/laporan/$laporanId'),
            headers: AppConfig.getHeaders(token),
          )
          .timeout(AppConfig.apiTimeout);

      AppConfig.log('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChecksheetReviewModel.fromJson(jsonData['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin mengakses laporan ini');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Silakan login kembali');
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      AppConfig.log('❌ Error fetching laporan: $e');
      throw Exception('Gagal memuat data laporan: $e');
    }
  }

  /// POST /api/laporan/{id}/approve
  /// Menyetujui laporan
  static Future<Map<String, dynamic>> approveLaporan(
    String token,
    int laporanId,
  ) async {
    // ✅ MODE SIMULASI: Return mock success response
    if (AppConfig.isSimulationMode) {
      AppConfig.log('🔄 Mode Simulasi: Approve laporan $laporanId');
      await Future.delayed(const Duration(milliseconds: 1000));
      return {
        'status': 'success',
        'message': 'Laporan berhasil disetujui (Mode Simulasi)',
        'data': {
          'laporan_id': laporanId,
          'new_status': 'Approved',
          'pdf_url': 'https://storage.kai.com/laporan-$laporanId.pdf',
        },
      };
    }

    // 🌐 MODE PRODUCTION: Hit API real
    try {
      AppConfig.log('🌐 Approving laporan: $laporanId');

      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/laporan/$laporanId/approve'),
            headers: AppConfig.getHeaders(token),
          )
          .timeout(AppConfig.apiTimeout);

      AppConfig.log('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return {
          'status': 'success',
          'message': jsonData['message'] ?? 'Laporan berhasil disetujui',
          'data': jsonData['data'],
        };
      } else if (response.statusCode == 422) {
        final jsonData = json.decode(response.body);
        throw Exception(
          jsonData['message'] ?? 'Laporan tidak dalam status Pending Approval',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin untuk menyetujui laporan');
      } else {
        throw Exception('Gagal menyetujui laporan: ${response.statusCode}');
      }
    } catch (e) {
      AppConfig.log('❌ Error approving laporan: $e');
      throw Exception('Gagal menyetujui laporan: $e');
    }
  }

  /// POST /api/laporan/{id}/reject
  /// Menolak laporan dengan catatan
  static Future<Map<String, dynamic>> rejectLaporan(
    String token,
    int laporanId,
    String catatanPengawas,
  ) async {
    // ✅ MODE SIMULASI: Return mock success response
    if (AppConfig.isSimulationMode) {
      AppConfig.log('🔄 Mode Simulasi: Reject laporan $laporanId');
      await Future.delayed(const Duration(milliseconds: 1000));
      return {
        'status': 'success',
        'message': 'Laporan berhasil ditolak (Mode Simulasi)',
        'data': {'laporan_id': laporanId, 'new_status': 'Rejected'},
      };
    }

    // 🌐 MODE PRODUCTION: Hit API real
    try {
      AppConfig.log('🌐 Rejecting laporan: $laporanId');

      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/laporan/$laporanId/reject'),
            headers: AppConfig.getHeaders(token),
            body: json.encode({'catatan_pengawas': catatanPengawas}),
          )
          .timeout(AppConfig.apiTimeout);

      AppConfig.log('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return {
          'status': 'success',
          'message': jsonData['message'] ?? 'Laporan berhasil ditolak',
          'data': jsonData['data'],
        };
      } else if (response.statusCode == 422) {
        final jsonData = json.decode(response.body);
        if (jsonData['errors'] != null) {
          throw Exception('Catatan penolakan wajib diisi');
        }
        throw Exception(
          jsonData['message'] ?? 'Laporan tidak dalam status Pending Approval',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin untuk menolak laporan');
      } else {
        throw Exception('Gagal menolak laporan: ${response.statusCode}');
      }
    } catch (e) {
      AppConfig.log('❌ Error rejecting laporan: $e');
      throw Exception('Gagal menolak laporan: $e');
    }
  }

  /// GET /api/laporan/{id}/download-pdf
  /// Mendapatkan URL download PDF
  static Future<String> getDownloadPdfUrl(String token, int laporanId) async {
    // ✅ MODE SIMULASI: Return mock PDF URL
    if (AppConfig.isSimulationMode) {
      AppConfig.log(
        '🔄 Mode Simulasi: Generate PDF URL untuk laporan $laporanId',
      );
      await Future.delayed(const Duration(milliseconds: 500));
      return 'https://storage.kai.com/laporan-$laporanId.pdf';
    }

    // 🌐 MODE PRODUCTION: Hit API real
    try {
      AppConfig.log('🌐 Getting PDF download URL: $laporanId');

      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/laporan/$laporanId/download-pdf'),
            headers: AppConfig.getHeaders(token),
          )
          .timeout(AppConfig.apiTimeout);

      AppConfig.log('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['data']['download_url'];
      } else if (response.statusCode == 403) {
        throw Exception('PDF belum tersedia. Laporan belum disetujui');
      } else if (response.statusCode == 404) {
        throw Exception('Laporan atau file PDF tidak ditemukan');
      } else {
        throw Exception(
          'Gagal mendapatkan URL download: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppConfig.log('❌ Error getting PDF URL: $e');
      throw Exception('Gagal mendapatkan URL download: $e');
    }
  }
}
