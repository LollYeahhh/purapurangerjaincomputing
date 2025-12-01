import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'change_password_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  String? _errorMessage;

  final TextEditingController _nippController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _validNipp = "123456";
  final String _validPassword = "password123";
  final bool _isFirstLogin = true;

  @override
  void dispose() {
    _nippController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    setState(() {
      _errorMessage = null;
    });

    final nipp = _nippController.text.trim();
    final password = _passwordController.text.trim();

    if (nipp.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'NIPP dan Kata Sandi tidak boleh kosong';
      });
      return;
    }

    if (nipp == _validNipp && password == _validPassword) {
      if (_isFirstLogin) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'NIPP atau Kata Sandi salah';
      });
    }
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

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: GoogleFonts.inter(fontSize: 16.0),
      decoration: InputDecoration(
        hintText: 'Masukkan Kata Sandi',
        hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[500],
            size: 20.0,
          ),
          onPressed: _togglePasswordVisibility,
        ),
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
    );
  }

  Widget _buildErrorMessage() {
    return Row(
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
}
