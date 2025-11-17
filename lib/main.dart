// main.dart
import 'package:flutter/material.dart';
import 'pages/login_page.dart';  // import halaman login (halaman lain diimport secara tidak langsung)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Dummy user data untuk simulasi kredensial
  static String dummyNIPP = '2345678910'; 
  static String dummyPassword = 'inisandilama'; // password awal default
  static bool isFirstLogin = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CP KaiChecksheet',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
