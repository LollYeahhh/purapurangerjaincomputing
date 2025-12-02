import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  /// State untuk pesan error
  String? _errorMessage;

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
      appBar: AppBar(
        title: Text(
          'Ganti Password',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Input Kata Sandi Saat Ini
            _buildPasswordField(
              controller: _currentCtrl,
              label: 'Kata Sandi Saat Ini',
              hint: 'Masukkan Kata Sandi Saat Ini',
              obscureText: _obscureCurrent,
              onToggle:
                  () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 16.0),

            /// Input Kata Sandi Baru
            _buildPasswordField(
              controller: _newCtrl,
              label: 'Kata Sandi Baru',
              hint: 'Masukkan Kata Sandi Baru',
              obscureText: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 16.0),

            /// Input Konfirmasi Kata Sandi Baru
            _buildPasswordField(
              controller: _confirmCtrl,
              label: 'Konfirmasi Kata Sandi',
              hint: 'Konfirmasi Kata Sandi Baru',
              obscureText: _obscureConfirm,
              onToggle:
                  () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            /// Pesan error jika validasi gagal
            if (_errorMessage != null) ...[
              const SizedBox(height: 16.0),
              _buildErrorMessage(),
            ],

            const SizedBox(height: 24.0),

            /// Tombol submit perubahan password
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// Widget reusable untuk password field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 16.0),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 14.0),
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF2C2A6B), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
            size: 20.0,
          ),
          onPressed: onToggle,
          iconSize: 20.0,
          padding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan pesan error
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 18.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk tombol submit
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: const Color(0xFF2C2A6B),
          foregroundColor: Colors.white,
        ),
        onPressed: _handleChangePassword,
        child: Text(
          'SIMPAN',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  /// Fungsi handler untuk validasi dan submit perubahan password
  void _handleChangePassword() {
    setState(() {
      _errorMessage = null; // Reset error message
    });

    final current = _currentCtrl.text.trim();
    final newPass = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    // Validasi input kosong
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi';
      });
      return;
    }

    // Validasi password baru minimal 6 karakter
    if (newPass.length < 6) {
      setState(() {
        _errorMessage = 'Password baru minimal 6 karakter';
      });
      return;
    }

    // Validasi konfirmasi password cocok
    if (newPass != confirm) {
      setState(() {
        _errorMessage = 'Konfirmasi password tidak cocok';
      });
      return;
    }

    // Jika semua validasi lolos, kirim ke server (ganti dengan API call)
    // Simulasi sukses
    _showSuccessDialog();
  }

  /// Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28.0),
                const SizedBox(width: 12.0),
                Text(
                  'Berhasil',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Password berhasil diubah. Silakan login kembali.',
              style: GoogleFonts.inter(fontSize: 14.0),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2A6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Kembali ke halaman login
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );
  }
}
