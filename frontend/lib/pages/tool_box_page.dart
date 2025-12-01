import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/inventory_item.dart';
import '../services/dummy_api_service.dart';
import 'error_page.dart';

/// ToolBoxPage - Halaman Checksheet Inventaris 1 (Tool Box)
class ToolBoxPage extends StatefulWidget {
  const ToolBoxPage({Key? key}) : super(key: key);

  @override
  State<ToolBoxPage> createState() => _ToolBoxPageState();
}

class _ToolBoxPageState extends State<ToolBoxPage> {
  // Daftar controller untuk input jumlah aktual tiap item
  final List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleSubmit(List<InventoryItem> items) {
    // Validasi: Pastikan semua field terisi
    for (int i = 0; i < items.length; i++) {
      final actualText = _controllers[i].text.trim();
      if (actualText.isEmpty) {
        // Data tidak valid (ada yang kosong) -> tampilkan halaman error
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ErrorPage()),
        );
        return;
      }
      // (Di sini bisa dilakukan validasi angka vs requiredCount jika diperlukan)
    }
    // Jika semua terisi, simulasi submit sukses
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Sukses'),
            content: const Text(
              'Checksheet Inventaris 1 (Tool Box) berhasil disimpan.',
            ),
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
          'Tool Box - Inventaris 1',
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
        child: FutureBuilder<List<InventoryItem>>(
          future: DummyApiService.fetchToolBoxItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Tampilkan loading saat data inventaris masih di-fetch
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!;
            // Inisialisasi controller sesuai jumlah item (sekali saja)
            if (_controllers.length < items.length) {
              _controllers.clear();
              for (var _ in items) {
                _controllers.add(TextEditingController());
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Daftar item inventaris
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama item dan jumlah seharusnya
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Jumlah seharusnya: ${item.requiredCount}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            // Input jumlah aktual
                            SizedBox(
                              width: 80.0,
                              child: TextFormField(
                                controller: _controllers[index],
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(fontSize: 16.0),
                                decoration: InputDecoration(
                                  hintText: '0',
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
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                // Tombol Simpan
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
                    onPressed: () => _handleSubmit(items),
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
