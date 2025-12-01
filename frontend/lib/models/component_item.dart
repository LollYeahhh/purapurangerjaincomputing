class ComponentItem {
  final String name;
  String?
  status; // status pengecekan: "Baik" / "Tidak Baik", null jika belum diisi

  ComponentItem({required this.name, this.status});
}
