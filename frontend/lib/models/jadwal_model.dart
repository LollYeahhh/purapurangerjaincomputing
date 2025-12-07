class JadwalModel {
  final int jadwalId;
  final String noKa;
  final String namaKa;
  final String jamBerangkat;
  final String statusLaporan; // "Baru", "Draft", "Pending Approval", "Approved"
  final int? laporanId;

  JadwalModel({
    required this.jadwalId,
    required this.noKa,
    required this.namaKa,
    required this.jamBerangkat,
    required this.statusLaporan,
    this.laporanId,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      jadwalId: json['jadwal_id'],
      noKa: json['no_ka'],
      namaKa: json['nama_ka'],
      jamBerangkat: json['jam_berangkat'],
      statusLaporan: json['status_laporan'],
      laporanId: json['laporan_id'],
    );
  }
}
