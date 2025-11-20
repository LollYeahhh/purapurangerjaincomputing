import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true; // state untuk mengatur visibilitas kata sandi

  @override
  Widget build(BuildContext context) {
    // Warna utama (oranye) diambil dari tema
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo perusahaan di atas form login
              Image.asset(
                'assets/logo_warna.png',
                height: 80.0,
              ),
              const SizedBox(height: 24.0),
              // Input NIPP
              TextFormField(
                style: GoogleFonts.inter(fontSize: 16.0),
                decoration: InputDecoration(
                  labelText: 'NIPP',
                  labelStyle: GoogleFonts.inter(fontSize: 14.0),
                  hintText: 'Masukkan NIPP',
                  hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[500]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              // Input Kata Sandi
              TextFormField(
                style: GoogleFonts.inter(fontSize: 16.0),
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  labelStyle: GoogleFonts.inter(fontSize: 14.0),
                  hintText: 'Masukkan Kata Sandi',
                  hintStyle: GoogleFonts.inter(fontSize: 14.0, color: Colors.grey[500]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              // Tombol MASUK
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), 
                    ),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,   
                  ),
                  onPressed: () {
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
      ),
    );
  }
}
