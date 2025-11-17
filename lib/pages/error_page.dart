import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
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
                // Icon gagal/error
                Icon(Icons.error_outline, color: Colors.red, size: 100),
                SizedBox(height: 16),
                Text(
                  'GAGAL',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Data yang diberikan tidak valid',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman sebelumnya
                    Navigator.pop(context);
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
