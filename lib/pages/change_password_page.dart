import 'package:flutter/material.dart';
import '../main.dart';  // to update dummy data and access current dummy password
import 'success_page.dart';
import 'error_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void _handleChangePassword() {
    String oldPass = _oldPassController.text;
    String newPass = _newPassController.text;
    String confirmPass = _confirmPassController.text;
    bool inputValid = true;

    // Validasi input
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      inputValid = false;
    }
    if (newPass != confirmPass) {
      // konfirmasi password tidak cocok
      inputValid = false;
    }
    if (oldPass != MyApp.dummyPassword) {
      // password lama tidak sesuai dengan yang tersimpan
      inputValid = false;
    }

    if (!inputValid) {
      // jika ada validasi gagal, navigasi ke halaman error
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ErrorPage()),
      );
    } else {
      // jika semua valid, perbarui password dummy dan flag isFirstLogin
      MyApp.dummyPassword = newPass;
      MyApp.isFirstLogin = false;
      // navigasi ke halaman sukses (menggantikan halaman ganti password)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
        automaticallyImplyLeading: false, // disable default back arrow
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form input password lama, baru, konfirmasi
                  TextField(
                    controller: _oldPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Saat Ini',
                      hintText: 'Masukkan Kata Sandi Saat Ini',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _newPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      hintText: 'Masukkan Kata Sandi Baru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi',
                      hintText: 'Masukkan Konfirmasi Kata Sandi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleChangePassword,
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
