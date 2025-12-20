import '../models/checksheet_review_model.dart';

/// Helper untuk generate mock data saat mode simulasi
class MockChecksheetData {
  /// Generate mock data untuk Tool Box & Tool Kit (Format Tipe 1)
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
      },
      logGangguan: [],
    );
  }

  /// Generate mock data untuk Mekanik & Genset (Format Tipe 2)
  static ChecksheetReviewModel getMockKomponen(int laporanId) {
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
        'mekanik': [
          {'kategori': 'SISTEM REM'},
          {
            'item_pemeriksaan': 'Tekanan Udara Utama',
            'standar': '7-9 Bar',
            'hasil_input': '8.2',
            'satuan': 'Bar',
          },
          {
            'item_pemeriksaan': 'Kondisi Brake Cylinder',
            'standar': 'Tidak Bocor',
            'hasil_input': 'Tidak Bocor',
            'satuan': '',
          },
          {
            'item_pemeriksaan': 'Ketebalan Kampas Rem',
            'standar': '≥ 5',
            'hasil_input': '6.5',
            'satuan': 'mm',
          },

          {'kategori': 'SISTEM SUSPENSI'},
          {
            'item_pemeriksaan': 'Kondisi Air Spring',
            'standar': 'Tidak Bocor',
            'hasil_input': 'Tidak Bocor',
            'satuan': '',
          },
          {
            'item_pemeriksaan': 'Tekanan Air Spring',
            'standar': '4-6 Bar',
            'hasil_input': '5.1',
            'satuan': 'Bar',
          },

          {'kategori': 'SISTEM RODA'},
          {
            'item_pemeriksaan': 'Kondisi Bearing',
            'standar': 'Tidak Bunyi',
            'hasil_input': 'Normal',
            'satuan': '',
          },
          {
            'item_pemeriksaan': 'Play Roda',
            'standar': '< 1',
            'hasil_input': '0.5',
            'satuan': 'mm',
          },
        ],
        'genset': [
          {'kategori': 'MESIN GENSET'},
          {
            'item_pemeriksaan': 'Tegangan Output',
            'standar': '380-400',
            'hasil_input': '395',
            'satuan': 'V',
          },
          {
            'item_pemeriksaan': 'Frekuensi',
            'standar': '50',
            'hasil_input': '50',
            'satuan': 'Hz',
          },
          {
            'item_pemeriksaan': 'Tekanan Oli',
            'standar': '3-5',
            'hasil_input': '4.2',
            'satuan': 'Bar',
          },
          {
            'item_pemeriksaan': 'Suhu Air Pendingin',
            'standar': '< 90',
            'hasil_input': '78',
            'satuan': '°C',
          },

          {'kategori': 'SISTEM PENDINGINAN'},
          {
            'item_pemeriksaan': 'Level Air Radiator',
            'standar': 'Normal',
            'hasil_input': 'Normal',
            'satuan': '',
          },
          {
            'item_pemeriksaan': 'Kondisi Kipas',
            'standar': 'Berfungsi',
            'hasil_input': 'Berfungsi',
            'satuan': '',
          },
        ],
      },
      logGangguan: [
        {
          'tanggal': '2025-12-17',
          'jenis_gangguan': 'Sistem Rem',
          'deskripsi': 'Tekanan udara sempat drop ke 6.5 Bar',
          'tindakan': 'Dicek kebocoran, tidak ditemukan masalah',
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

  /// Generate mock data untuk Mekanik 2 (Format Tipe 3)
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
        'mekanik_2': [
          {'kategori': 'PEMERIKSAAN BOGIE'},
          {
            'item_pemeriksaan': 'Kondisi As Roda',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Tidak ada keausan abnormal',
          },
          {
            'item_pemeriksaan': 'Kondisi Primary Spring',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Elastisitas normal',
          },
          {
            'item_pemeriksaan': 'Kondisi Secondary Spring',
            'hasil_pemeriksaan': 'PERLU PERHATIAN',
            'keterangan': 'Ditemukan sedikit korosi, perlu dilumasi',
          },

          {'kategori': 'SISTEM KOPLING'},
          {
            'item_pemeriksaan': 'Kondisi Automatic Coupler',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Fungsi normal',
          },
          {
            'item_pemeriksaan': 'Kondisi Semi Permanent Coupler',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Tidak ada kelonggaran',
          },
        ],
      },
      logGangguan: [],
    );
  }

  /// Generate mock data untuk Electric (Format Tipe 3)
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
        'electric': [
          {'kategori': 'SISTEM KELISTRIKAN UTAMA'},
          {
            'item_pemeriksaan': 'Tegangan Baterai',
            'hasil_pemeriksaan': 'NORMAL',
            'keterangan': '24.5V - dalam range normal',
          },
          {
            'item_pemeriksaan': 'Kondisi MCB',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Semua MCB berfungsi',
          },
          {
            'item_pemeriksaan': 'Kondisi Kabel Power',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Tidak ada kerusakan isolasi',
          },

          {'kategori': 'SISTEM PENCAHAYAAN'},
          {
            'item_pemeriksaan': 'Lampu Utama',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Semua berfungsi',
          },
          {
            'item_pemeriksaan': 'Lampu Kabin',
            'hasil_pemeriksaan': 'PERLU PERBAIKAN',
            'keterangan': '1 lampu mati di kabin 3, perlu ganti',
          },
          {
            'item_pemeriksaan': 'Lampu Emergency',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Tested - berfungsi normal',
          },

          {'kategori': 'SISTEM HVAC'},
          {
            'item_pemeriksaan': 'Kondisi AC Unit 1',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Pendinginan optimal',
          },
          {
            'item_pemeriksaan': 'Kondisi AC Unit 2',
            'hasil_pemeriksaan': 'BAIK',
            'keterangan': 'Pendinginan optimal',
          },
        ],
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

      case 'komponen':
      case 'mekanik':
      case 'genset':
        return getMockKomponen(laporanId);

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
