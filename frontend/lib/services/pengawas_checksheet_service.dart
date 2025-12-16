import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checksheet_review_model.dart';

class PengawasChecksheetService {
  // ✅ GANTI dengan base URL API Anda
  static const String baseUrl = 'https://your-api-url.com/api';

  // GET: Ambil detail laporan
  static Future<ChecksheetReviewModel> getLaporanDetail(
    String token,
    int laporanId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laporan/$laporanId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChecksheetReviewModel.fromJson(data['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin');
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST: Approve laporan
  static Future<Map<String, dynamic>> approveLaporan(
    String token,
    int laporanId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/laporan/$laporanId/approve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'pdf_url': data['data']['pdf_url'],
        };
      } else if (response.statusCode == 422) {
        throw Exception(data['message']);
      } else {
        throw Exception('Gagal menyetujui laporan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST: Reject laporan
  static Future<Map<String, dynamic>> rejectLaporan(
    String token,
    int laporanId,
    String catatanPengawas,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/laporan/$laporanId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'catatan_pengawas': catatanPengawas}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else if (response.statusCode == 422) {
        throw Exception(data['message']);
      } else {
        throw Exception('Gagal menolak laporan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET: Download PDF
  static Future<String> getDownloadUrl(String token, int laporanId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/laporan/$laporanId/download-pdf'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['download_url'];
      } else if (response.statusCode == 403) {
        throw Exception('PDF belum tersedia');
      } else {
        throw Exception('Gagal mendapatkan URL download');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
