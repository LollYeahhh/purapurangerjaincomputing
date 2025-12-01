import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/component_item.dart';
import '../services/dummy_api_service.dart';
import 'error_page.dart';

/// MechanicFormPage - Halaman Form Komponen (Mekanik)
class MechanicFormPage extends StatefulWidget {
  const MechanicFormPage({Key? key}) : super(key: key);

  @override
  State<MechanicFormPage> createState() => _MechanicFormPageState();
}

class _MechanicFormPageState extends State<MechanicFormPage> {
  late Future<List<ComponentItem>> _futureComponents;
  List<ComponentItem> _componentsList = []; // akan diisi setelah fetch

  @override
  void initState() {
    super.initState();
    _futureComponents = DummyApiService.fetchMechanicComponents();
  }

  void _handleSubmit() {
    // Cek apakah semua komponen sudah diisi statusnya
    for (var item in _componentsList) {
      if (item.status == null) {
        // Ada yang belum dipilih status -> tampilkan error
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ErrorPage()),
        );
        return;
      }
    }
    // Semua terisi -> simpan (dummy sukses)
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Sukses'),
            content: const Text('Form Komponen Mekanik berhasil disimpan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // tutup dialog
                  Navigator.pop(context); // kembali ke dashboard
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Mekanik',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: const Color(0xFF2C2A6B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<ComponentItem>>(
          future: _futureComponents,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            // Saat data komponen mekanik sudah didapat
            final items = snapshot.data!;
            if (_componentsList.isEmpty) {
              _componentsList = items;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _componentsList.length,
                    itemBuilder: (context, index) {
                      final item = _componentsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama komponen
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            // Dropdown pilihan status (Baik / Tidak Baik)
                            SizedBox(
                              width: 120.0,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: item.status,
                                decoration: InputDecoration(
                                  hintText: 'Pilih status',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFF2C2A6B),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Baik',
                                    child: Text('Baik'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Tidak Baik',
                                    child: Text('Tidak Baik'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _componentsList[index].status = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xFF2C2A6B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: _handleSubmit,
                    child: Text(
                      'SIMPAN',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
