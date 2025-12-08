class ChecksheetItemModel {
  final String itemPemeriksaan;
  String hasilInput; // BAIK, RUSAK, TIADA
  String keterangan;
  String jumlah;

  ChecksheetItemModel({
    required this.itemPemeriksaan,
    this.hasilInput = '',
    this.keterangan = '',
    this.jumlah = '1 Brg',
  });

  Map<String, dynamic> toJson() {
    return {
      'item_pemeriksaan': itemPemeriksaan,
      'hasil_input': hasilInput,
      'keterangan': keterangan,
    };
  }

  factory ChecksheetItemModel.fromJson(Map<String, dynamic> json) {
    return ChecksheetItemModel(
      itemPemeriksaan: json['item_pemeriksaan'],
      hasilInput: json['hasil_input'] ?? '',
      keterangan: json['keterangan'] ?? '',
      jumlah: json['jumlah'] ?? '1 Brg',
    );
  }
}

class ChecksheetInventarisData {
  final String namaSheet;
  final List<ChecksheetItemModel> items;

  ChecksheetInventarisData({required this.namaSheet, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'nama_sheet': namaSheet,
      'data': items.map((item) => item.toJson()).toList(),
    };
  }
}
