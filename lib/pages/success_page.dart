import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80.0),
              const SizedBox(height: 16.0),
              Text(
                'SUKSES',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Kata Sandi Anda berhasil diperbarui',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/')); 
                },
                child: Text(
                  'KEMBALI',
                  style: GoogleFonts.plusJakartaSans(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
