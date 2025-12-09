class ChecksheetKomponenModel {
  String itemPemeriksaan;
  String standar;
  String hasilInput;
  String keterangan;

  ChecksheetKomponenModel({
    required this.itemPemeriksaan,
    required this.standar,
    this.hasilInput = '',
    this.keterangan = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'item_pemeriksaan': itemPemeriksaan,
      'standar': standar,
      'hasil_input': hasilInput,
      'keterangan': keterangan,
    };
  }

  factory ChecksheetKomponenModel.fromJson(Map<String, dynamic> json) {
    return ChecksheetKomponenModel(
      itemPemeriksaan: json['item_pemeriksaan'] ?? '',
      standar: json['standar'] ?? '',
      hasilInput: json['hasil_input'] ?? '',
      keterangan: json['keterangan'] ?? '',
    );
  }
}
