class ChecksheetReviewModel {
  final int laporanId;
  final String noKa;
  final String namaKa;
  final String status;
  final String namaMekanik;
  final String submittedAt;
  final String? catatanPengawas;
  final Map<String, dynamic> sheets;
  final List<dynamic> logGangguan;

  ChecksheetReviewModel({
    required this.laporanId,
    required this.noKa,
    required this.namaKa,
    required this.status,
    required this.namaMekanik,
    required this.submittedAt,
    this.catatanPengawas,
    required this.sheets,
    required this.logGangguan,
  });

  factory ChecksheetReviewModel.fromJson(Map<String, dynamic> json) {
    return ChecksheetReviewModel(
      laporanId: json['master_info']['laporan_id'] ?? 0,
      noKa: json['master_info']['no_ka'] ?? '',
      namaKa: json['master_info']['nama_ka'] ?? '',
      status: json['master_info']['status'] ?? '',
      namaMekanik: json['master_info']['nama_mekanik'] ?? '',
      submittedAt: json['master_info']['submitted_at'] ?? '',
      catatanPengawas: json['master_info']['catatan_pengawas'],
      sheets: json['sheets'] ?? {},
      logGangguan: json['log_gangguan'] ?? [],
    );
  }
}

// Model untuk item inventaris (Tool Box / Tool Kit)
class InventarisReviewItemModel {
  final String itemPemeriksaan;
  final String standar;
  final String? kondisi;
  final String? jumlah;
  final String? keterangan;

  InventarisReviewItemModel({
    required this.itemPemeriksaan,
    required this.standar,
    this.kondisi,
    this.jumlah,
    this.keterangan,
  });

  factory InventarisReviewItemModel.fromJson(Map<String, dynamic> json) {
    return InventarisReviewItemModel(
      itemPemeriksaan: json['item_pemeriksaan'] ?? '',
      standar: json['standar'] ?? '',
      kondisi: json['kondisi'],
      jumlah: json['jumlah'],
      keterangan: json['keterangan'],
    );
  }
}
