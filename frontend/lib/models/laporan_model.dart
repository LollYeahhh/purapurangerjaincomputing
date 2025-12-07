class LaporanPendingModel {
  final int laporanId;
  final String noKa;
  final String namaKa;
  final String namaMekanik;
  final DateTime submittedAt;

  LaporanPendingModel({
    required this.laporanId,
    required this.noKa,
    required this.namaKa,
    required this.namaMekanik,
    required this.submittedAt,
  });

  factory LaporanPendingModel.fromJson(Map<String, dynamic> json) {
    return LaporanPendingModel(
      laporanId: json['laporan_id'],
      noKa: json['no_ka'],
      namaKa: json['nama_ka'],
      namaMekanik: json['nama_mekanik'],
      submittedAt: DateTime.parse(json['submitted_at']),
    );
  }
}

class LaporanApprovedModel {
  final int laporanId;
  final String noKa;
  final String namaKa;
  final String namaMekanik;
  final DateTime approvedAt;
  final String pdfUrl;

  LaporanApprovedModel({
    required this.laporanId,
    required this.noKa,
    required this.namaKa,
    required this.namaMekanik,
    required this.approvedAt,
    required this.pdfUrl,
  });

  factory LaporanApprovedModel.fromJson(Map<String, dynamic> json) {
    return LaporanApprovedModel(
      laporanId: json['laporan_id'],
      noKa: json['no_ka'],
      namaKa: json['nama_ka'],
      namaMekanik: json['nama_mekanik'],
      approvedAt: DateTime.parse(json['approved_at']),
      pdfUrl: json['pdf_url'],
    );
  }
}
