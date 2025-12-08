class LaporanPendingModel {
  final int laporanId;
  final String noKa;
  final String namaKa;
  final String namaMekanik;
  final DateTime submittedAt;
  final String pdfUrl;
  final String status;

  LaporanPendingModel({
    required this.laporanId,
    required this.noKa,
    required this.namaKa,
    required this.namaMekanik,
    required this.submittedAt,
    required this.pdfUrl,
    required this.status,
  });

  factory LaporanPendingModel.fromJson(Map<String, dynamic> json) {
    return LaporanPendingModel(
      laporanId: json['laporan_id'],
      noKa: json['no_ka'],
      namaKa: json['nama_ka'],
      namaMekanik: json['nama_mekanik'],
      submittedAt: DateTime.parse(json['submitted_at']),
      pdfUrl: json['pdf_url'] ?? '',
      status: json['status'] ?? 'approved',
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
  final String status;

  LaporanApprovedModel({
    required this.laporanId,
    required this.noKa,
    required this.namaKa,
    required this.namaMekanik,
    required this.approvedAt,
    required this.pdfUrl,
    required this.status,
  });

  factory LaporanApprovedModel.fromJson(Map<String, dynamic> json) {
    return LaporanApprovedModel(
      laporanId: json['laporan_id'],
      noKa: json['no_ka'],
      namaKa: json['nama_ka'],
      namaMekanik: json['nama_mekanik'],
      approvedAt: DateTime.parse(json['approved_at']),
      pdfUrl: json['pdf_url'],
      status: json['status'] ?? 'approved',
    );
  }
}
