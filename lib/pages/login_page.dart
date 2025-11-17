import 'package:flutter/material.dart';
import '../main.dart';  // import MyApp for dummy data reference
import 'change_password_page.dart';
import 'error_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers for text fields
  final TextEditingController _nippController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // method to handle login button press
  void _handleLogin() {
    String enteredNIPP = _nippController.text;
    String enteredPassword = _passwordController.text;

    if (enteredNIPP.isEmpty || enteredPassword.isEmpty) {
      // jika ada input yang kosong, tampilkan halaman error
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ErrorPage()),
      );
    } else {
      // cek kredensial dummy
      if (enteredNIPP == MyApp.dummyNIPP && enteredPassword == MyApp.dummyPassword) {
        if (MyApp.isFirstLogin) {
          // Login pertama kali -> navigasi ke halaman ganti password
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordPage()),
          );
        } else {
          // Login sukses (bukan pertama kali) -> 
          // (Dalam kasus ini, langsung menuju halaman utama aplikasi. 
          // Karena backend tidak diimplementasikan, kita tidak membuat halaman utama di sini)
          // Untuk demo, kita bisa beri informasi login berhasil.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login berhasil!'))
          );
          // TODO: Navigasi ke beranda utama jika diperlukan.
        }
      } else {
        // kredensial salah -> navigasi ke halaman error
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ErrorPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo perusahaan (misalnya logo KAI)
                  // Untuk demo, gunakan placeholder container atau text.
                  // Ganti dengan Image.asset('assets/kai_logo.png') jika tersedia.
                  Container(
                    height: 150,
                    child: Center(child: Text('LOGO KAI', style: TextStyle(fontSize: 24))),
                  ),
                  SizedBox(height: 32),
                  // Input NIPP
                  TextField(
                    controller: _nippController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'NIPP',
                      hintText: 'Masukkan NIPP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Input Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      hintText: 'Masukkan Kata Sandi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Tombol MASUK
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text('MASUK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}