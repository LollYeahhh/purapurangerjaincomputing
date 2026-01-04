import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/jadwal_model.dart';
import '../models/laporan_model.dart';
import '../models/checksheet_review_model.dart';

class ApiService {
  /// ✅ SIMULASI: GET Dashboard Mekanik - Jadwal (Dummy Data)
  static Future<List<JadwalModel>> getDashboardJadwal(String token) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // ✅ DUMMY DATA sesuai dengan desain referensi
    final List<Map<String, dynamic>> dummyJadwalData = [
      {
        'jadwal_id': 1,
        'no_ka': 'KA 120',
        'nama_ka': 'Argo Bromo Anggrek',
        'jam_berangkat': '19:00',
        'status_laporan': 'Baru',
        'laporan_id': null,
      },
      {
        'jadwal_id': 2,
        'no_ka': 'KA 108',
        'nama_ka': 'Taksaka',
        'jam_berangkat': '17:00',
        'status_laporan': 'Draft',
        'laporan_id': 45,
      },
      {
        'jadwal_id': 3,
        'no_ka': 'KA 233',
        'nama_ka': 'Probowangi',
        'jam_berangkat': '17:30',
        'status_laporan': 'Menunggu',
        'laporan_id': 46,
      },
      {
        'jadwal_id': 4,
        'no_ka': 'KA 10',
        'nama_ka': 'Bima',
        'jam_berangkat': '16:00',
        'status_laporan': 'Ditinjau',
        'laporan_id': 47,
      },
      {
        'jadwal_id': 5,
        'no_ka': 'KA 7048',
        'nama_ka': 'Gajayana',
        'jam_berangkat': '14:00',
        'status_laporan': 'Diterima',
        'laporan_id': 48,
      },
      {
        'jadwal_id': 6,
        'no_ka': 'KA 0301',
        'nama_ka': 'Joglosemarkerto',
        'jam_berangkat': '17:00',
        'status_laporan': 'Ditolak',
        'laporan_id': 49,
      },
    ];

    // Parse dummy data ke model
    List<JadwalModel> jadwalList = [];
    for (var item in dummyJadwalData) {
      jadwalList.add(JadwalModel.fromJson(item));
    }

    return jadwalList;

    /* 
    ========================================
    🚀 PRODUCTION API CALL (Gunakan kode ini saat integrasi dengan backend)
    ========================================
    
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/dashboard/jadwal'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          List<JadwalModel> jadwalList = [];
          for (var item in jsonData['data']) {
            jadwalList.add(JadwalModel.fromJson(item));
          }
          return jadwalList;
        } else {
          throw Exception('Failed to load jadwal');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated');
      } else {
        throw Exception('Failed to load jadwal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    */
  }

  /// ✅ SIMULASI: GET Dashboard Pengawas (Dummy Data)
  static Future<Map<String, dynamic>> getDashboardPengawas(String token) async {
    await Future.delayed(const Duration(seconds: 1));

    final Map<String, dynamic> dummyPengawasData = {
      'pending_approval': [
        {
          'laporan_id': 46,
          'no_ka': 'KA 233',
          'nama_ka': 'Probowangi',
          'nama_mekanik': 'Gilang Yanuar',
          'submitted_at': '2025-12-08T10:30:00Z',
        },
        {
          'laporan_id': 47,
          'no_ka': 'KA 10',
          'nama_ka': 'Bima',
          'nama_mekanik': 'Ahmad Rizki',
          'submitted_at': '2025-12-08T09:00:00Z',
        },
      ],
      'riwayat_approved': [
        {
          'laporan_id': 50,
          'no_ka': 'KA 108',
          'nama_ka': 'Taksaka',
          'nama_mekanik': 'Ahmad Rizki',
          'approved_at': '2025-12-07T16:30:00Z',
          'pdf_url': 'https://example.com/laporan/50.pdf',
          'status': 'rejected', // ✅ Status ditolak
        },
        {
          'laporan_id': 48,
          'no_ka': 'KA 7048',
          'nama_ka': 'Gajayana',
          'nama_mekanik': 'Gilang Yanuar',
          'approved_at': '2025-12-06T15:30:00Z',
          'pdf_url': 'https://example.com/laporan/48.pdf',
          'status': 'approved', // ✅ Status disetujui
        },
        {
          'laporan_id': 49,
          'no_ka': 'KA 0301',
          'nama_ka': 'Joglosemarkerto',
          'nama_mekanik': 'Budi Santoso',
          'approved_at': '2025-12-05T14:20:00Z',
          'pdf_url': 'https://example.com/laporan/49.pdf',
          'status': 'rejected', // ✅ Status ditolak
        },
        {
          'laporan_id': 44,
          'no_ka': 'KA 120',
          'nama_ka': 'Argo Bromo Anggrek',
          'nama_mekanik': 'Ahmad Rizki',
          'approved_at': '2025-12-04T14:20:00Z',
          'pdf_url': 'https://example.com/laporan/44.pdf',
          'status': 'approved',
        },
        {
          'laporan_id': 43,
          'no_ka': 'KA 108',
          'nama_ka': 'Taksaka',
          'nama_mekanik': 'Budi Santoso',
          'approved_at': '2025-12-03T10:15:00Z',
          'pdf_url': 'https://example.com/laporan/43.pdf',
          'status': 'approved',
        },
      ],
    };

    List<LaporanPendingModel> pendingList = [];
    List<LaporanApprovedModel> approvedList = [];

    // Parse pending approval
    for (var item in dummyPengawasData['pending_approval']) {
      pendingList.add(LaporanPendingModel.fromJson(item));
    }

    // Parse riwayat dan sortir berdasarkan waktu terbaru
    for (var item in dummyPengawasData['riwayat_approved']) {
      approvedList.add(LaporanApprovedModel.fromJson(item));
    }

    // ✅ Sortir riwayat berdasarkan waktu (terbaru di atas)
    approvedList.sort((a, b) => b.approvedAt.compareTo(a.approvedAt));

    return {'pending_approval': pendingList, 'riwayat_approved': approvedList};
  }

  /* 
    ========================================
    🚀 PRODUCTION API CALL (Gunakan kode ini saat integrasi dengan backend)
    ========================================
    
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/dashboard/pengawas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          List<LaporanPendingModel> pendingList = [];
          List<LaporanApprovedModel> approvedList = [];

          for (var item in jsonData['data']['pending_approval']) {
            pendingList.add(LaporanPendingModel.fromJson(item));
          }

          for (var item in jsonData['data']['riwayat_approved']) {
            approvedList.add(LaporanApprovedModel.fromJson(item));
          }

          return {
            'pending_approval': pendingList,
            'riwayat_approved': approvedList,
          };
        } else {
          throw Exception('Failed to load dashboard');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin untuk mengakses sumber daya ini');
      } else {
        throw Exception('Failed to load dashboard');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    */

  // ========================================
  // ✅ METHOD BARU UNTUK REVIEW CHECKSHEET
  // ========================================

  /// ✅ SIMULASI: GET Laporan Detail untuk Review Pengawas
  static Future<ChecksheetReviewModel> getLaporanDetail(
    String token,
    int laporanId,
  ) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // ✅ DUMMY DATA untuk simulasi
    final Map<String, dynamic> dummyDetailData = {
      'laporan_id': laporanId,
      'no_ka': 'KA 233',
      'nama_ka': 'Probowangi',
      'nama_mekanik': 'Gilang Yanuar',
      'status': 'Pending Approval',
      'submitted_at': '2025-12-08T10:30:00Z',
      'catatan_pengawas': null,
      'sheets': {
        'mekanik': [
          {'kategori': 'PERALATAN MEKANIK'},
          {
            'item_pemeriksaan': 'Tang Kombinasi',
            'standar': '2 buah',
            'hasil_input': '2',
            'satuan': 'buah',
          },
          {
            'item_pemeriksaan': 'Obeng Plus',
            'standar': '3 buah',
            'hasil_input': '3',
            'satuan': 'buah',
          },
          {
            'item_pemeriksaan': 'Obeng Minus',
            'standar': '3 buah',
            'hasil_input': '3',
            'satuan': 'buah',
          },
          {'kategori': 'PERALATAN UKUR'},
          {
            'item_pemeriksaan': 'Multimeter Digital',
            'standar': '1 unit',
            'hasil_input': '1',
            'satuan': 'unit',
          },
        ],
        'genset': [
          {'kategori': 'PEMERIKSAAN GENSET'},
          {
            'item_pemeriksaan': 'Tegangan Output',
            'standar': '220V ± 10V',
            'hasil_input': '225',
            'satuan': 'V',
          },
          {
            'item_pemeriksaan': 'Frekuensi',
            'standar': '50Hz ± 1Hz',
            'hasil_input': '50',
            'satuan': 'Hz',
          },
          {
            'item_pemeriksaan': 'Tekanan Oli',
            'standar': '3-5 bar',
            'hasil_input': '4',
            'satuan': 'bar',
          },
        ],
      },
      'log_gangguan': [],
    };

    return ChecksheetReviewModel.fromJson(dummyDetailData);

    /* 
    ========================================
    🚀 PRODUCTION API CALL
    ========================================
    
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/pengawas/laporan/$laporanId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return ChecksheetReviewModel.fromJson(jsonData['data']);
        } else {
          throw Exception('Failed to load laporan detail');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated');
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else {
        throw Exception('Failed to load laporan detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    */
  }

  /// ✅ SIMULASI: Approve Laporan
  static Future<Map<String, dynamic>> approveLaporan(
    String token,
    int laporanId,
  ) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // ✅ SIMULASI: Selalu berhasil
    return {
      'status': 'success',
      'message': 'Laporan berhasil disetujui',
      'data': {
        'laporan_id': laporanId,
        'status': 'Approved',
        'approved_at': DateTime.now().toIso8601String(),
      },
    };

    /* 
    ========================================
    🚀 PRODUCTION API CALL
    ========================================
    
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/pengawas/laporan/$laporanId/approve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return jsonData;
        } else {
          throw Exception('Failed to approve laporan');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated');
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else {
        throw Exception('Failed to approve laporan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    */
  }

  /// ✅ SIMULASI: Reject Laporan
  static Future<Map<String, dynamic>> rejectLaporan(
    String token,
    int laporanId,
    String alasan,
  ) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // ✅ SIMULASI: Selalu berhasil
    return {
      'status': 'success',
      'message': 'Laporan berhasil ditolak',
      'data': {
        'laporan_id': laporanId,
        'status': 'Rejected',
        'catatan_pengawas': alasan,
        'rejected_at': DateTime.now().toIso8601String(),
      },
    };

    /* 
    ========================================
    🚀 PRODUCTION API CALL
    ========================================
    
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/pengawas/laporan/$laporanId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'alasan': alasan,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return jsonData;
        } else {
          throw Exception('Failed to reject laporan');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated');
      } else if (response.statusCode == 404) {
        throw Exception('Laporan tidak ditemukan');
      } else if (response.statusCode == 400) {
        throw Exception('Alasan penolakan wajib diisi');
      } else {
        throw Exception('Failed to reject laporan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    */
  }
}
