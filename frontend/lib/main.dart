import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'), // Bahasa Indonesia
        Locale('en', 'US'), // English
      ],
      locale: const Locale('id', 'ID'),
      home: const LoginPage(),
    );
  }
}
