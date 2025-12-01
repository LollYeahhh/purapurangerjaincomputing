import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/log_provider.dart';
import 'error_page.dart';

/// LogFormPage - Halaman formulir tambah Log Gangguan
class LogFormPage extends StatefulWidget {
  const LogFormPage({Key? key}) : super(key: key);

  @override
  State<LogFormPage> createState() => _LogFormPageState();
}

class _LogFormPageState extends State<LogFormPage> {
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      // Deskripsi kosong -> tampilkan halaman error
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ErrorPage()),
      );
      return;
    }
    // Tambah log melalui Provider
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    await logProvider.addLog(desc);
    // Kembali ke list dengan indikator sukses
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Log Gangguan',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deskripsi Gangguan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              style: GoogleFonts.inter(fontSize: 16.0),
              decoration: InputDecoration(
                hintText: 'Masukkan deskripsi gangguan',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: Colors.grey[400],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Color(0xFF2C2A6B), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
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
                onPressed: _handleSave,
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
        ),
      ),
    );
  }
}
