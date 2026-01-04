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

  /// Generate mock data untuk Mekanik & Genset
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
        'mekanik': {
          'kategori': [
            {
              'nama_kategori': 'ALAT TOLAK TARIK',
              'items': [
                {
                  'item_pemeriksaan': 'a. Kopler Mekanik',
                  'standar': 'Lengkap',
                  'hasil_input': 'LENGKAP',
                  'keterangan': 'Dalam kondisi baik',
                },
                {
                  'item_pemeriksaan': 'b. Selisih Tinggi Buffer',
                  'standar': 'Baik/Utuh',
                  'hasil_input': 'BAIK',
                  'keterangan': 'Tidak ada kerusakan',
                },
                {
                  'item_pemeriksaan': 'c. Klaw dan Pen Klaw',
                  'standar': 'Baik',
                  'hasil_input': 'BAIK',
                  'keterangan': 'Berfungsi normal',
                },
              ],
            },
            {
              'nama_kategori': 'BOGIE & PERANGKATNYA',
              'items': [
                {
                  'item_pemeriksaan': 'a. Pegas Daun/ Primer/ Sekunder',
                  'standar': 'Baik',
                  'hasil_input': 'BAIK',
                  'keterangan': 'Elastisitas normal',
                },
                {
                  'item_pemeriksaan': 'b. Bantalan Gandar/ Bearing Axlebox',
                  'standar': 'Baik/Utuh',
                  'hasil_input': 'BAIK',
                  'keterangan': 'Tidak ada kebocoran',
                },
              ],
            },
            {
              'nama_kategori': 'PENGEREMAN',
              'items': [
                {
                  'item_pemeriksaan': 'a. Tekanan Udara Pengereman',
                  'standar': '4.8 - 5.2 Kg/cm²',
                  'hasil_input': '5.0',
                  'keterangan': 'Tekanan stabil',
                },
                {
                  'item_pemeriksaan': 'b. Kebocoran Saluran Pengereman',
                  'standar': 'Baik',
                  'hasil_input': 'BAIK',
                  'keterangan': 'Tidak ada kebocoran',
                },
              ],
            },
          ],
        },
        'genset': {
          'kategori': [
            {
              'nama_kategori': 'KONDISI GENSET AWAL',
              'items': [
                {
                  'item_pemeriksaan': 'a. Bocoran/ Tetesan Pelumas, air, HSD',
                  'standar': 'Tidak Ada',
                  'hasil_input': 'TIDAK_ADA',
                  'keterangan': 'Bersih',
                },
                {
                  'item_pemeriksaan': 'b. HSD didalam pipa ukur',
                  'standar': 'Cukup',
                  'hasil_input': 'CUKUP',
                  'keterangan': 'Level normal',
                },
              ],
            },
            {
              'nama_kategori': 'MENGHIDUPKAN GENSET',
              'items': [
                {
                  'item_pemeriksaan': 'a. Tekanan Pelumas',
                  'standar': '2,5 - 6 Bar',
                  'hasil_input': '4.2',
                  'keterangan': 'Normal',
                },
                {
                  'item_pemeriksaan': 'e. Frekuensi genset tanpa beban',
                  'standar': '48 - 51 Hz',
                  'hasil_input': '50',
                  'keterangan': 'Stabil',
                },
              ],
            },
          ],
        },
        // ✅ DATA BARU: Mekanik 2 Per Gerbong
        'mekanik2_gerbong': [
          {
            'gerbong_id': 'KMP-101',
            'nama_gerbong': 'Gerbong 1',
            'jumlah_item': 15,
            'status': 'Sudah diperiksa',
            'items': [
              {
                'item_pemeriksaan': 'Pintu Masuk',
                'hasil_input': 'BAIK',
                'keterangan': 'Berfungsi normal',
              },
              {
                'item_pemeriksaan': 'Pintu Keluar Darurat',
                'hasil_input': 'BAIK',
                'keterangan': 'Terkunci dengan baik',
              },
              {
                'item_pemeriksaan': 'Jendela Kaca',
                'hasil_input': 'BAIK',
                'keterangan': 'Tidak ada retakan',
              },
              {
                'item_pemeriksaan': 'Tempat Duduk',
                'hasil_input': 'BAIK',
                'keterangan': 'Bersih dan kokoh',
              },
              {
                'item_pemeriksaan': 'Sandaran Tangan',
                'hasil_input': 'BAIK',
                'keterangan': 'Semua terpasang',
              },
            ],
          },
          {
            'gerbong_id': 'KMP-102',
            'nama_gerbong': 'Gerbong 2',
            'jumlah_item': 15,
            'status': 'Sudah diperiksa',
            'items': [
              {
                'item_pemeriksaan': 'Pintu Masuk',
                'hasil_input': 'RUSAK',
                'keterangan': 'Engsel agak longgar, perlu dikencangkan',
              },
              {
                'item_pemeriksaan': 'Pintu Keluar Darurat',
                'hasil_input': 'BAIK',
                'keterangan': 'Normal',
              },
              {
                'item_pemeriksaan': 'Jendela Kaca',
                'hasil_input': 'BAIK',
                'keterangan': 'Bersih',
              },
              {
                'item_pemeriksaan': 'Tempat Duduk',
                'hasil_input': 'BAIK',
                'keterangan': 'Kondisi baik',
              },
            ],
          },
          {
            'gerbong_id': 'KMP-103',
            'nama_gerbong': 'Gerbong 3',
            'jumlah_item': 15,
            'status': 'Sudah diperiksa',
            'items': [
              {
                'item_pemeriksaan': 'Pintu Masuk',
                'hasil_input': 'BAIK',
                'keterangan': 'Normal',
              },
              {
                'item_pemeriksaan': 'Pintu Keluar Darurat',
                'hasil_input': 'BAIK',
                'keterangan': 'Terkunci',
              },
            ],
          },
        ],
        // ✅ DATA BARU: Elektrik Per Gerbong
        'elektrik_gerbong': [
          {
            'gerbong_id': 'KMP-101',
            'nama_gerbong': 'Gerbong 1',
            'jumlah_item': 12,
            'status': 'Sudah diperiksa',
            'items': [
              {
                'item_pemeriksaan': 'Lampu Utama',
                'hasil_input': 'BAIK',
                'keterangan': 'Semua menyala',
              },
              {
                'item_pemeriksaan': 'Lampu Emergency',
                'hasil_input': 'BAIK',
                'keterangan': 'Tested - berfungsi',
              },
              {
                'item_pemeriksaan': 'AC Unit',
                'hasil_input': 'BAIK',
                'keterangan': 'Dingin optimal',
              },
              {
                'item_pemeriksaan': 'Stop Kontak',
                'hasil_input': 'BAIK',
                'keterangan': 'Semua berfungsi',
              },
            ],
          },
          {
            'gerbong_id': 'KMP-102',
            'nama_gerbong': 'Gerbong 2',
            'jumlah_item': 12,
            'status': 'Sudah diperiksa',
            'items': [
              {
                'item_pemeriksaan': 'Lampu Utama',
                'hasil_input': 'RUSAK',
                'keterangan': '2 lampu mati, perlu diganti',
              },
              {
                'item_pemeriksaan': 'Lampu Emergency',
                'hasil_input': 'BAIK',
                'keterangan': 'Berfungsi',
              },
              {
                'item_pemeriksaan': 'AC Unit',
                'hasil_input': 'BAIK',
                'keterangan': 'Normal',
              },
            ],
          },
          {
            'gerbong_id': 'KMP-103',
            'nama_gerbong': 'Gerbong 3',
            'jumlah_item': 12,
            'status': 'Sudah diperiksa',
            'items': [
              {
                'item_pemeriksaan': 'Lampu Utama',
                'hasil_input': 'BAIK',
                'keterangan': 'Semua normal',
              },
              {
                'item_pemeriksaan': 'AC Unit',
                'hasil_input': 'BAIK',
                'keterangan': 'Dingin',
              },
            ],
          },
        ],
        // ✅ DATA BARU: Gangguan
        'gangguan': [
          {
            'id': 1,
            'waktu': '2025-01-04 10:30',
            'gerbong': 'KMP-102',
            'deskripsi': 'AC Gerbong 2 tidak dingin',
            'solusi':
                'Dilakukan pengecekan freon, ditemukan kebocoran pada pipa. Sudah ditambal sementara.',
            'status': 'Selesai',
          },
          {
            'id': 2,
            'waktu': '2025-01-04 11:15',
            'gerbong': 'KMP-102',
            'deskripsi': 'Pintu otomatis lambat menutup',
            'solusi':
                'Dilakukan adjustment pada motor pintu dan pelumasan rel',
            'status': 'Selesai',
          },
          {
            'id': 3,
            'waktu': '2025-01-04 14:20',
            'gerbong': 'KMP-103',
            'deskripsi': 'Lampu kabin sebelah kanan tidak menyala',
            'solusi': 'Penggantian ballast lampu, sudah berfungsi normal',
            'status': 'Selesai',
          },
        ],
      },
      logGangguan: [],
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
      case 'mekanik2_gerbong':
      case 'elektrik_gerbong':
      case 'gangguan':
        return getMockKomponen(laporanId);

      default:
        return getMockInventaris(laporanId);
    }
  }
}
