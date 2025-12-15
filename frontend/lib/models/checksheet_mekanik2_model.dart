class ChecksheetMekanik2KategoriModel {
  final String namaKategori;
  final List<ChecksheetMekanik2ItemModel> items;

  ChecksheetMekanik2KategoriModel({
    required this.namaKategori,
    required this.items,
  });
}

class ChecksheetMekanik2ItemModel {
  final String itemPemeriksaan;
  final String standar;
  final String tipeInput; // 'button' atau 'number'
  final String? unit; // Untuk tipe 'number'
  final List<String>? options; // Untuk tipe 'button'
  String? kondisi; // Nilai yang dipilih/diinput
  String? keterangan; // Keterangan tambahan

  ChecksheetMekanik2ItemModel({
    required this.itemPemeriksaan,
    required this.standar,
    required this.tipeInput,
    this.unit,
    this.options,
    this.kondisi,
    this.keterangan,
  });
}
