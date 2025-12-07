import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'change_password_page.dart';
import '../mekanik/mekanik_home_page.dart';
import '../pengawas/pengawas_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _isLoading = false;

  final TextEditingController _nippController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              Center(
                child: Image.asset('assets/logo_warna.png', height: 120.0),
              ),
              const SizedBox(height: 60.0),

              Text(
                'NIPP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildNippTextField(),
              const SizedBox(height: 24.0),

              Text(
                'Kata Sandi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildPasswordTextField(),

              if (_errorMessage != null) ...[
                const SizedBox(height: 8.0),
                _buildErrorMessage(),
              ],

              const SizedBox(height: 32.0),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNippTextField() {
    return TextFormField(
      controller: _nippController,
      style: GoogleFonts.inter(fontSize: 16.0),
      enabled: !_isLoading,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      style: GoogleFonts.inter(fontSize: 16.0),
      obscureText: _obscurePassword,
      enabled: !_isLoading,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[500],
            size: 20.0,
          ),
          onPressed: _isLoading ? null : _togglePasswordVisibility,
          iconSize: 20.0,
          padding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }

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
        onPressed: _isLoading ? null : _handleLogin,
        child:
            _isLoading
                ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() async {
    setState(() {
      _errorMessage = null;
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

    // Show loading
    setState(() {
      _isLoading = true;
    });

    // Call login service
    final user = await AuthService.login(nipp, password);

    setState(() {
      _isLoading = false;
    });

    if (user == null) {
      setState(() {
        _errorMessage = 'NIPP atau Kata Sandi salah';
      });
      return;
    }

    // Login berhasil - cek apakah login pertama kali
    if (user.isFirstLogin) {
      // Navigasi ke halaman ganti password
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordPage(user: user)),
      );
    } else {
      // Login bukan pertama kali - arahkan ke dashboard sesuai role
      _navigateToHomePage(user);
    }
  }

  void _navigateToHomePage(User user) {
    Widget homePage;

    switch (user.role) {
      case UserRole.mekanik:
        homePage = MekanikHomePage(user: user);
        break;
      case UserRole.pengawas:
        homePage = PengawasHomePage(user: user);
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homePage),
    );
  }
}
