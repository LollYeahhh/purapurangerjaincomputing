import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'error_page.dart';
import 'success_page.dart';

/// ChangePasswordPage - Halaman untuk mengganti password pertama kali
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  /// State untuk visibilitas tiap password field
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  /// Controllers untuk mengambil nilai input
  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Logo perusahaan di atas form
              Center(
                child: Image.asset('assets/logo_warna.png', height: 120.0),
              ),
              const SizedBox(height: 60.0),

              /// Label Kata Sandi Saat Ini
              Text(
                'Kata Sandi Saat Ini',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              /// Input Kata Sandi Saat Ini
              _buildPasswordField(
                controller: _currentCtrl,
                hint: 'Masukkan Kata Sandi Saat Ini',
                obscureText: _obscureCurrent,
                onToggle:
                    () => setState(() => _obscureCurrent = !_obscureCurrent),
              ),
              const SizedBox(height: 24.0),

              /// Label Kata Sandi Baru
              Text(
                'Kata Sandi Baru',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              /// Input Kata Sandi Baru
              _buildPasswordField(
                controller: _newCtrl,
                hint: 'Masukkan Kata Sandi Baru',
                obscureText: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 24.0),

              /// Label Konfirmasi Kata Sandi
              Text(
                'Konfirmasi Kata Sandi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              /// Input Konfirmasi Kata Sandi
              _buildPasswordField(
                controller: _confirmCtrl,
                hint: 'Konfirmasi Kata Sandi',
                obscureText: _obscureConfirm,
                onToggle:
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),

              const SizedBox(height: 32.0),

              /// Tombol submit perubahan password
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget reusable untuk password field dengan rounded border
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 16.0),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFF2C2A6B), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[500],
            size: 20.0,
          ),
          onPressed: onToggle,
          iconSize: 20.0,
          padding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  /// Widget untuk tombol submit
  Widget _buildSubmitButton() {
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
        onPressed: _handleChangePassword,
        child: Text(
          'MASUK',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  /// Fungsi handler untuk validasi dan submit perubahan password
  void _handleChangePassword() {
    final current = _currentCtrl.text.trim();
    final newPass = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    // Validasi input kosong
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorPage()),
      );
      return;
    }

    // Validasi password baru minimal 6 karakter
    if (newPass.length < 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorPage()),
      );
      return;
    }

    // Validasi konfirmasi password cocok
    if (newPass != confirm) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorPage()),
      );
      return;
    }

    // Jika semua validasi lolos, navigasi ke halaman sukses
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessPage()),
    );
  }
}
