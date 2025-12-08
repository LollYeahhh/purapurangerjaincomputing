import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/jadwal_model.dart';
import '../models/laporan_model.dart';

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
}
