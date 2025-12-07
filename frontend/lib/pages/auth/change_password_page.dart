import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../common/success_page.dart';
import '../common/error_page.dart';
import '../auth/login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  const ChangePasswordPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Logo Section
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
                child: Center(
                  child: Image.asset(
                    'assets/logo_warna.png', // Ganti dengan path logo Anda
                    height: 100,
                    width: 250,
                  ),
                ),
              ),

              // Form Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kata Sandi Saat Ini
                      Text(
                        'Kata Sandi Saat Ini',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _buildPasswordTextField(
                        controller: _oldPasswordController,
                        obscureText: _obscureOldPassword,
                        onToggle:
                            () => setState(
                              () => _obscureOldPassword = !_obscureOldPassword,
                            ),
                        hintText: 'Masukkan Kata Sandi Saat Ini',
                      ),
                      const SizedBox(height: 20.0),

                      // Kata Sandi Baru
                      Text(
                        'Kata Sandi Baru',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _buildPasswordTextField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        onToggle:
                            () => setState(
                              () => _obscureNewPassword = !_obscureNewPassword,
                            ),
                        hintText: 'Masukkan Kata Sandi Baru',
                      ),
                      const SizedBox(height: 20.0),

                      // Konfirmasi Kata Sandi
                      Text(
                        'Konfirmasi Kata Sandi',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _buildPasswordTextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        onToggle:
                            () => setState(
                              () =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                            ),
                        hintText: 'Konfirmasi Kata Sandi',
                      ),

                      const SizedBox(height: 40.0),

                      // Tombol Masuk
                      _buildSaveButton(),

                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 14.0),
      obscureText: obscureText,
      enabled: !_isLoading,
      decoration: InputDecoration(
        hintText: hintText,
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
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
            size: 20.0,
          ),
          onPressed: _isLoading ? null : onToggle,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color(0xFF2C2A6B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        onPressed: _isLoading ? null : _handleChangePassword,
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
      ),
    );
  }

  void _handleChangePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _navigateToErrorPage('Semua field harus diisi');
      return;
    }

    if (newPassword.length < 6) {
      _navigateToErrorPage('Kata sandi baru minimal 6 karakter');
      return;
    }

    if (newPassword != confirmPassword) {
      _navigateToErrorPage('Konfirmasi kata sandi tidak cocok');
      return;
    }

    if (oldPassword == newPassword) {
      _navigateToErrorPage(
        'Kata sandi baru harus berbeda dengan kata sandi lama',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await AuthService.updatePassword(
      widget.user.nipp,
      oldPassword,
      newPassword,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (success) {
      _navigateToSuccessPage();
    } else {
      _navigateToErrorPage('Kata sandi lama tidak sesuai');
    }
  }

  void _navigateToSuccessPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (context) => SuccessPage(
              message:
                  'Kata Sandi Anda berhasil diperbarui.\nSilakan login kembali dengan kata sandi baru.',
              onBackPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
      ),
      (route) => false,
    );
  }

  void _navigateToErrorPage(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ErrorPage(
              message: message,
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
      ),
    );
  }
}
