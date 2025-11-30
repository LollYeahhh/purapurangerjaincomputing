import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'pages/change_password_page.dart';
import 'pages/success_page.dart';
import 'pages/error_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Primary color swatch untuk tema aplikasi (Orange KAI)
    const MaterialColor primarySwatch = MaterialColor(0xFFEC7C04, <int, Color>{
      50: Color(0xFFFFF8E7),
      100: Color(0xFFFFECC0),
      200: Color(0xFFFFDF96),
      300: Color(0xFFFFD26C),
      400: Color(0xFFFFC74D),
      500: Color(0xFFEC7C04),
      600: Color(0xFFD97404),
      700: Color(0xFFC56A03),
      800: Color(0xFFB16103),
      900: Color(0xFF944F02),
    });

    return MaterialApp(
      title: 'CP KaiChecksheet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatch,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),

      /// Rute awal aplikasi dimulai dari LoginPage
      home: const LoginPage(),
    );
  }
}
