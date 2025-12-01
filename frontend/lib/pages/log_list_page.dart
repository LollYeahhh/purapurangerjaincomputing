import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/log_provider.dart';
import 'log_form_page.dart';

/// LogListPage - Halaman daftar Log Gangguan
class LogListPage extends StatelessWidget {
  const LogListPage({Key? key}) : super(key: key);

  // Fungsi utilitas untuk format tanggal
  String _formatDate(DateTime date) {
    // Format: DD-MM-YYYY HH:MM
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final d = twoDigits(date.day);
    final m = twoDigits(date.month);
    final y = date.year;
    final hh = twoDigits(date.hour);
    final mm = twoDigits(date.minute);
    return "$d-$m-$y $hh:$mm";
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = Provider.of<LogProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log Gangguan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: const Color(0xFF2C2A6B),
        foregroundColor: Colors.white,
      ),
      body:
          logProvider.loading
              ? const Center(child: CircularProgressIndicator())
              : logProvider.logs.isEmpty
              ? Center(
                child: Text(
                  'Belum ada log gangguan.',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: logProvider.logs.length,
                itemBuilder: (context, index) {
                  final entry = logProvider.logs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        entry.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(entry.date),
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2C2A6B),
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navigasi ke halaman tambah log
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogFormPage()),
          );
          if (result == true) {
            // Setelah kembali, tampilkan notifikasi snack bar jika berhasil ditambah
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Log gangguan berhasil ditambahkan.'),
              ),
            );
          }
        },
      ),
    );
  }
}
