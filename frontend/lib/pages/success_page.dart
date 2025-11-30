import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SuccessPage - Halaman notifikasi berhasil untuk perubahan password
class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Icon sukses (checkmark dalam lingkaran hijau)
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF27AE60),
                    width: 12.0,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Color(0xFF27AE60),
                    size: 80.0,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),

              /// Text SUKSES
              Text(
                'SUKSES',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF27AE60),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16.0),

              /// Pesan sukses
              Text(
                'Kata Sandi Anda berhasil diperbarui',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87),
              ),
              const SizedBox(height: 80.0),

              /// Tombol KEMBALI
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk tombol kembali
  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
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
        onPressed: () {
          // Kembali ke halaman login (halaman pertama)
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Text(
          'KEMBALI',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
