import '../models/checksheet_review_model.dart';

/// Helper untuk generate mock data saat mode simulasi
class MockChecksheetData {
  /// Generate mock data untuk Tool Box & Tool Kit (Format List)
  static ChecksheetReviewModel getMockInventaris(int laporanId) {
    return ChecksheetReviewModel(
      laporanId: laporanId,
      noKa: 'KA-15',
      namaKa: 'Argo Dwipangga',
      status: 'Pending Approval',
      namaMekanik: 'Gilang Yanuar',
      submittedAt:
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      catatanPengawas: null,
      sheets: {
        'tool_box': [
          {
            'item_pemeriksaan': 'Tang Kombinasi',
            'standar': '2',
            'kondisi': 'BAIK',
            'jumlah': '2',
            'keterangan': 'Lengkap dan berfungsi dengan baik',
          },
          {
            'item_pemeriksaan': 'Obeng Plus',
            'standar': '3',
            'kondisi': 'BAIK',
            'jumlah': '3',
            'keterangan': 'Semua dalam kondisi baik',
          },
          {
            'item_pemeriksaan': 'Obeng Minus',
            'standar': '3',
            'kondisi': 'BAIK',
            'jumlah': '3',
            'keterangan': '',
          },
          {
            'item_pemeriksaan': 'Kunci Inggris',
            'standar': '1',
            'kondisi': 'BAIK',
            'jumlah': '1',
            'keterangan': 'Berfungsi normal',
          },
          {
            'item_pemeriksaan': 'Tang Potong',
            'standar': '2',
            'kondisi': 'RUSAK',
            'jumlah': '1',
            'keterangan': 'Satu unit rusak, perlu penggantian',
          },
        ],
        'tool_kit': [
          {
            'item_pemeriksaan': 'Kunci Ring Set',
            'standar': '1 Set',
            'kondisi': 'BAIK',
            'jumlah': '1 Set',
            'keterangan': 'Lengkap semua ukuran',
          },
          {
            'item_pemeriksaan': 'Kunci Sok Set',
            'standar': '1 Set',
            'kondisi': 'BAIK',
            'jumlah': '1 Set',
            'keterangan': '',
          },
          {
            'item_pemeriksaan': 'Tang Buaya',
            'standar': '1',
            'kondisi': 'BAIK',
            'jumlah': '1',
            'keterangan': 'Tajam dan berfungsi',
          },
        ],
        // ✅ Format BENAR untuk Mekanik & Genset dengan kategori
        'mekanik': {
          'kategori': [
            {
              'nama_kategori': 'ALAT TOLAK TARIK (COUPLER)',
              'items': [
                {
                  'item_pemeriksaan':
                      'Auto Coupler (knuckle, shank, centre lock, yoke, draft key)',
                  'standar': 'Berfungsi Normal',
                  'hasil_input': 'Berfungsi Normal',
                  'keterangan': 'Semua komponen dalam kondisi baik',
                },
                {
                  'item_pemeriksaan': 'Kunci kopling (lock)',
                  'standar': 'Terkunci Sempurna',
                  'hasil_input': 'Terkunci Sempurna',
                  'keterangan': '',
                },
              ],
            },
            {
              'nama_kategori': 'BOGIE & RODA',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi ban berjalan (tread)',
                  'standar': 'Tidak Ada Keausan',
                  'hasil_input': 'Tidak Ada Keausan',
                  'keterangan': 'Permukaan roda halus',
                },
                {
                  'item_pemeriksaan': 'Kondisi bearing roda',
                  'standar': 'Tidak Bunyi',
                  'hasil_input': 'Normal',
                  'keterangan': 'Tidak ada bunyi abnormal',
                },
                {
                  'item_pemeriksaan': 'Play roda (lateral & vertikal)',
                  'standar': '< 1 mm',
                  'hasil_input': '0.5 mm',
                  'keterangan': 'Dalam batas normal',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM REM',
              'items': [
                {
                  'item_pemeriksaan': 'Tekanan udara utama',
                  'standar': '7-9 Bar',
                  'hasil_input': '8.2 Bar',
                  'keterangan': 'Tekanan stabil',
                },
                {
                  'item_pemeriksaan': 'Kondisi brake cylinder',
                  'standar': 'Tidak Bocor',
                  'hasil_input': 'Tidak Bocor',
                  'keterangan': 'Seal dalam kondisi baik',
                },
                {
                  'item_pemeriksaan': 'Ketebalan kampas rem',
                  'standar': '≥ 5 mm',
                  'hasil_input': '6.5 mm',
                  'keterangan': 'Masih layak pakai',
                },
                {
                  'item_pemeriksaan': 'Kondisi pipa udara',
                  'standar': 'Tidak Bocor',
                  'hasil_input': 'Tidak Bocor',
                  'keterangan': '',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM SUSPENSI',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi air spring',
                  'standar': 'Tidak Bocor',
                  'hasil_input': 'Tidak Bocor',
                  'keterangan': 'Tekanan normal',
                },
                {
                  'item_pemeriksaan': 'Tekanan air spring',
                  'standar': '4-6 Bar',
                  'hasil_input': '5.1 Bar',
                  'keterangan': 'Dalam range optimal',
                },
                {
                  'item_pemeriksaan': 'Kondisi shock absorber',
                  'standar': 'Berfungsi Normal',
                  'hasil_input': 'Berfungsi Normal',
                  'keterangan': 'Tidak ada kebocoran oli',
                },
              ],
            },
          ],
        },
        'genset': {
          'kategori': [
            {
              'nama_kategori': 'MESIN GENSET',
              'items': [
                {
                  'item_pemeriksaan': 'Tegangan output',
                  'standar': '380-400 V',
                  'hasil_input': '395 V',
                  'keterangan': 'Tegangan stabil',
                },
                {
                  'item_pemeriksaan': 'Frekuensi',
                  'standar': '50 Hz',
                  'hasil_input': '50 Hz',
                  'keterangan': 'Sesuai standar',
                },
                {
                  'item_pemeriksaan': 'Tekanan oli mesin',
                  'standar': '3-5 Bar',
                  'hasil_input': '4.2 Bar',
                  'keterangan': 'Tekanan normal',
                },
                {
                  'item_pemeriksaan': 'Suhu air pendingin',
                  'standar': '< 90 °C',
                  'hasil_input': '78 °C',
                  'keterangan': 'Suhu optimal',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM BAHAN BAKAR',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi filter bahan bakar',
                  'standar': 'Bersih',
                  'hasil_input': 'Bersih',
                  'keterangan': 'Filter dalam kondisi baik',
                },
                {
                  'item_pemeriksaan': 'Kondisi pipa bahan bakar',
                  'standar': 'Tidak Bocor',
                  'hasil_input': 'Tidak Bocor',
                  'keterangan': '',
                },
                {
                  'item_pemeriksaan': 'Level bahan bakar',
                  'standar': '> 50%',
                  'hasil_input': '75%',
                  'keterangan': 'Cukup untuk operasional',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM PENDINGINAN',
              'items': [
                {
                  'item_pemeriksaan': 'Level air radiator',
                  'standar': 'Normal',
                  'hasil_input': 'Normal',
                  'keterangan': 'Level sesuai indikator',
                },
                {
                  'item_pemeriksaan': 'Kondisi kipas pendingin',
                  'standar': 'Berfungsi',
                  'hasil_input': 'Berfungsi',
                  'keterangan': 'Putaran normal',
                },
                {
                  'item_pemeriksaan': 'Kondisi selang radiator',
                  'standar': 'Tidak Bocor',
                  'hasil_input': 'Tidak Bocor',
                  'keterangan': '',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM KELISTRIKAN',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi alternator',
                  'standar': 'Charging Normal',
                  'hasil_input': 'Charging Normal',
                  'keterangan': 'Output stabil',
                },
                {
                  'item_pemeriksaan': 'Kondisi baterai starter',
                  'standar': '≥ 12V',
                  'hasil_input': '12.8V',
                  'keterangan': 'Baterai sehat',
                },
                {
                  'item_pemeriksaan': 'Kondisi kabel listrik',
                  'standar': 'Tidak Rusak',
                  'hasil_input': 'Tidak Rusak',
                  'keterangan': 'Isolasi baik',
                },
              ],
            },
          ],
        },
        // ✅ LIST GERBONG untuk Mekanik 2
        'mekanik_2': {
          'gerbong_list': [
            {
              'gerbong_id': 'G-101',
              'nama_gerbong': 'Gerbong Penumpang 101',
              'status': 'Selesai Diperbaiki',
              'jumlah_item': 8,
              'item_selesai': 8,
              'catatan': 'Semua komponen bogie dalam kondisi baik',
            },
            {
              'gerbong_id': 'G-102',
              'nama_gerbong': 'Gerbong Penumpang 102',
              'status': 'Selesai Diperbaiki',
              'jumlah_item': 8,
              'item_selesai': 8,
              'catatan': 'Spring secondary perlu pelumasan berkala',
            },
            {
              'gerbong_id': 'G-103',
              'nama_gerbong': 'Gerbong Penumpang 103',
              'status': 'Dalam Perbaikan',
              'jumlah_item': 8,
              'item_selesai': 5,
              'catatan': 'Penggantian bearing roda sedang dilakukan',
            },
            {
              'gerbong_id': 'G-104',
              'nama_gerbong': 'Gerbong Penumpang 104',
              'status': 'Selesai Diperbaiki',
              'jumlah_item': 8,
              'item_selesai': 8,
              'catatan': 'Kondisi optimal',
            },
          ],
        },
        // ✅ LIST GERBONG untuk Elektrik
        'elektrik': {
          'gerbong_list': [
            {
              'gerbong_id': 'G-101',
              'nama_gerbong': 'Gerbong Penumpang 101',
              'status': 'Selesai Diperbaiki',
              'jumlah_item': 12,
              'item_selesai': 12,
              'catatan': 'Sistem kelistrikan & HVAC normal',
            },
            {
              'gerbong_id': 'G-102',
              'nama_gerbong': 'Gerbong Penumpang 102',
              'status': 'Perlu Perbaikan',
              'jumlah_item': 12,
              'item_selesai': 11,
              'catatan': 'Lampu kabin 3 perlu diganti',
            },
            {
              'gerbong_id': 'G-103',
              'nama_gerbong': 'Gerbong Penumpang 103',
              'status': 'Selesai Diperbaiki',
              'jumlah_item': 12,
              'item_selesai': 12,
              'catatan': 'Semua sistem berfungsi normal',
            },
            {
              'gerbong_id': 'G-104',
              'nama_gerbong': 'Gerbong Penumpang 104',
              'status': 'Selesai Diperbaiki',
              'jumlah_item': 12,
              'item_selesai': 12,
              'catatan': 'AC unit berfungsi optimal',
            },
          ],
        },
      },
      logGangguan: [
        {
          'tanggal': '2025-12-17',
          'jenis_gangguan': 'Sistem Rem',
          'deskripsi': 'Tekanan udara sempat drop ke 6.5 Bar saat pengujian',
          'tindakan': 'Dicek seluruh jalur pipa, tidak ditemukan kebocoran',
          'status': 'Resolved',
        },
      ],
    );
  }

  /// Get mock data based on sheet type
  static ChecksheetReviewModel getMockData(int laporanId, String sheetType) {
    // Semua data sudah ada di getMockInventaris
    return getMockInventaris(laporanId);
  }
}
