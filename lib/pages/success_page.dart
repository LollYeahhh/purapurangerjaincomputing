import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon sukses
                Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
                SizedBox(height: 16),
                Text(
                  'SUKSES',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Kata Sandi Anda berhasil diperbarui',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman login (pop semua halaman hingga login)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text('KEMBALI'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
