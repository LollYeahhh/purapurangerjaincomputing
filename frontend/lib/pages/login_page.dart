import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'change_password_page.dart';

/// LoginPage - Halaman utama untuk autentikasi pengguna
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// State untuk mengatur visibilitas kata sandi
  bool _obscurePassword = true;

  /// State untuk menampilkan pesan error
  String? _errorMessage;

  /// Controllers untuk mengambil nilai input
  final TextEditingController _nippController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Dummy credentials untuk simulasi (ganti dengan API call di production)
  final String _validNipp = "123456";
  final String _validPassword = "password123";
  final bool _isFirstLogin = true; // Flag untuk cek login pertama kali

  @override
  void dispose() {
    _nippController.dispose();
    _passwordController.dispose();
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
              /// Logo perusahaan di atas form login
              Center(
                child: Image.asset('assets/logo_warna.png', height: 120.0),
              ),
              const SizedBox(height: 60.0),

              /// Label NIPP
              Text(
                'NIPP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              /// Input field untuk NIPP
              _buildNippTextField(),

              const SizedBox(height: 24.0),

              /// Label Kata Sandi
              Text(
                'Kata Sandi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              /// Input field untuk Kata Sandi
              _buildPasswordTextField(),

              /// Pesan error jika login gagal
              if (_errorMessage != null) ...[
                const SizedBox(height: 8.0),
                _buildErrorMessage(),
              ],

              const SizedBox(height: 32.0),

              /// Tombol MASUK
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk TextField NIPP
  Widget _buildNippTextField() {
    return TextFormField(
      controller: _nippController,
      style: GoogleFonts.inter(fontSize: 16.0),
      decoration: InputDecoration(
        hintText: 'Masukkan NIPP',
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
      ),
      keyboardType: TextInputType.number,
    );
  }

  /// Widget untuk TextField Kata Sandi dengan toggle visibility
  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      style: GoogleFonts.inter(fontSize: 16.0),
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Masukkan Kata Sandi',
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
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[500],
            size: 20.0,
          ),
          onPressed: _togglePasswordVisibility,
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

  /// Widget untuk tombol login
  Widget _buildLoginButton() {
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
        onPressed: _handleLogin,
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

  /// Fungsi untuk toggle visibilitas password
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Fungsi handler untuk proses login dengan validasi
  void _handleLogin() {
    setState(() {
      _errorMessage = null; // Reset error message
    });

    final nipp = _nippController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi input kosong
    if (nipp.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'NIPP dan Kata Sandi tidak boleh kosong';
      });
      return;
    }

    // Validasi kredensial (ganti dengan API call di production)
    if (nipp == _validNipp && password == _validPassword) {
      // Login berhasil - cek apakah login pertama kali
      if (_isFirstLogin) {
        // Navigasi ke halaman ganti password
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
      } else {
        // Navigasi ke halaman utama/dashboard
        // Navigator.pushReplacementNamed(context, '/home');
        print('Login berhasil - ke dashboard');
      }
    } else {
      // Login gagal - tampilkan error
      setState(() {
        _errorMessage = 'NIPP atau Kata Sandi salah';
      });
    }
  }
}
