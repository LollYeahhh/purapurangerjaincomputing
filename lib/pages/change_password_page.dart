import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // State untuk visibilitas tiap password field
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Controllers untuk mengambil nilai input (validasi front-end)
  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    // Jangan lupa dispose controller untuk mencegah memory leak
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Kata Sandi Saat Ini
            TextFormField(
              controller: _currentCtrl,
              style: GoogleFonts.inter(fontSize: 16.0),
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Kata Sandi Saat Ini',
                labelStyle: GoogleFonts.inter(fontSize: 14.0),
                hintText: 'Masukkan Kata Sandi Saat Ini',
                hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[500]),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrent = !_obscureCurrent;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Input Kata Sandi Baru
            TextFormField(
              controller: _newCtrl,
              style: GoogleFonts.inter(fontSize: 16.0),
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                labelStyle: GoogleFonts.inter(fontSize: 14.0),
                hintText: 'Masukkan Kata Sandi Baru',
                hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[500]),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNew = !_obscureNew;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Input Konfirmasi Kata Sandi Baru
            TextFormField(
              controller: _confirmCtrl,
              style: GoogleFonts.inter(fontSize: 16.0),
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Kata Sandi',
                labelStyle: GoogleFonts.inter(fontSize: 14.0),
                hintText: 'Konfirmasi Kata Sandi Baru',
                hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[500]),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Tombol MASUK untuk submit perubahan password
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Validasi input sederhana di frontend
                  final current = _currentCtrl.text.trim();
                  final newPass = _newCtrl.text.trim();
                  final confirm = _confirmCtrl.text.trim();
                  if (current.isNotEmpty && newPass.isNotEmpty && confirm.isNotEmpty && newPass == confirm) {
                    // Password baru terisi dan konfirmasi cocok -> navigasi ke halaman sukses
                    Navigator.pushNamed(context, '/success');
                  } else {
                    // Jika input kosong atau konfirmasi tidak cocok -> navigasi ke halaman error
                    Navigator.pushNamed(context, '/error');
                  }
                },
                child: Text(
                  'MASUK',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.0, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
