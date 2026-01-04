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

  /// Generate mock data untuk Gerbong Fase
  static ChecksheetReviewModel getMockGerbong(int laporanId) {
    return ChecksheetReviewModel(
      laporanId: laporanId,
      noKa: 'KA-15',
      namaKa: 'Argo Dwipangga',
      status: 'Pending Approval',
      namaMekanik: 'Gilang Yanuar',
      submittedAt:
          DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      catatanPengawas: null,
      sheets: {
        'gerbong_fase': [
          {
            'fase': 'Fase 1',
            'no_gerbong': 'G-101',
            'kondisi_umum': 'BAIK',
            'catatan': 'Semua sistem normal',
          },
          {
            'fase': 'Fase 1',
            'no_gerbong': 'G-102',
            'kondisi_umum': 'BAIK',
            'catatan': 'Pendingin AC perlu dibersihkan',
          },
          {
            'fase': 'Fase 2',
            'no_gerbong': 'G-201',
            'kondisi_umum': 'PERLU PERHATIAN',
            'catatan': 'Pintu otomatis agak lambat',
          },
          {
            'fase': 'Fase 2',
            'no_gerbong': 'G-202',
            'kondisi_umum': 'BAIK',
            'catatan': 'Semua sistem normal',
          },
        ],
      },
      logGangguan: [],
    );
  }

  /// Generate mock data untuk Mekanik 2
  static ChecksheetReviewModel getMockMekanik2(int laporanId) {
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
        'mekanik_2': {
          'kategori': [
            {
              'nama_kategori': 'PEMERIKSAAN BOGIE',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi as roda',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Tidak ada keausan abnormal',
                },
                {
                  'item_pemeriksaan': 'Kondisi primary spring',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Elastisitas normal',
                },
                {
                  'item_pemeriksaan': 'Kondisi secondary spring',
                  'hasil_pemeriksaan': 'PERLU PERHATIAN',
                  'keterangan': 'Ditemukan sedikit korosi, perlu dilumasi',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM KOPLING',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi automatic coupler',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Fungsi normal',
                },
                {
                  'item_pemeriksaan': 'Kondisi semi permanent coupler',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Tidak ada kelonggaran',
                },
              ],
            },
          ],
        },
      },
      logGangguan: [],
    );
  }

  /// Generate mock data untuk Elektrik
  static ChecksheetReviewModel getMockElektrik(int laporanId) {
    return ChecksheetReviewModel(
      laporanId: laporanId,
      noKa: 'KA-15',
      namaKa: 'Argo Dwipangga',
      status: 'Pending Approval',
      namaMekanik: 'Budi Santoso',
      submittedAt:
          DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      catatanPengawas: null,
      sheets: {
        'elektrik': {
          'kategori': [
            {
              'nama_kategori': 'SISTEM KELISTRIKAN UTAMA',
              'items': [
                {
                  'item_pemeriksaan': 'Tegangan baterai',
                  'hasil_pemeriksaan': 'NORMAL',
                  'keterangan': '24.5V - dalam range normal',
                },
                {
                  'item_pemeriksaan': 'Kondisi MCB',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Semua MCB berfungsi',
                },
                {
                  'item_pemeriksaan': 'Kondisi kabel power',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Tidak ada kerusakan isolasi',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM PENCAHAYAAN',
              'items': [
                {
                  'item_pemeriksaan': 'Lampu utama',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Semua berfungsi',
                },
                {
                  'item_pemeriksaan': 'Lampu kabin',
                  'hasil_pemeriksaan': 'PERLU PERBAIKAN',
                  'keterangan': '1 lampu mati di kabin 3, perlu ganti',
                },
                {
                  'item_pemeriksaan': 'Lampu emergency',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Tested - berfungsi normal',
                },
              ],
            },
            {
              'nama_kategori': 'SISTEM HVAC',
              'items': [
                {
                  'item_pemeriksaan': 'Kondisi AC unit 1',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Pendinginan optimal',
                },
                {
                  'item_pemeriksaan': 'Kondisi AC unit 2',
                  'hasil_pemeriksaan': 'BAIK',
                  'keterangan': 'Pendinginan optimal',
                },
              ],
            },
          ],
        },
      },
      logGangguan: [
        {
          'tanggal': '2025-12-16',
          'jenis_gangguan': 'Sistem Pencahayaan',
          'deskripsi': 'Lampu kabin 3 mati',
          'tindakan': 'Akan diganti pada maintenance berikutnya',
          'status': 'Pending',
        },
      ],
    );
  }

  /// Get mock data based on sheet type
  static ChecksheetReviewModel getMockData(int laporanId, String sheetType) {
    switch (sheetType.toLowerCase()) {
      case 'inventaris':
      case 'tool_box':
      case 'tool_kit':
        return getMockInventaris(laporanId);

      case 'gerbong':
      case 'gerbong_fase':
        return getMockGerbong(laporanId);

      case 'mekanik_2':
        return getMockMekanik2(laporanId);

      case 'electric':
      case 'elektrik':
        return getMockElektrik(laporanId);

      default:
        return getMockInventaris(laporanId);
    }
  }
}
