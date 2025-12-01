import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dashboard_menu_item.dart';
import 'tool_box_page.dart';
import 'tool_kit_page.dart';
import 'mechanic_form_page.dart';
import 'electric_form_page.dart';
import 'mechanic_matrix_page.dart';
import 'electric_matrix_page.dart';
import 'log_list_page.dart';

/// DashboardPage - Halaman Dashboard Mekanik (menu utama)
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Mekanik',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: const Color(0xFF2C2A6B), // Warna biru gelap KAI
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            DashboardMenuItem(
              icon: Icons.home_repair_service, // ikon toolbox
              title: 'Tool Box',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ToolBoxPage()),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.handyman, // ikon toolkit
              title: 'Tool Kit',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ToolKitPage()),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.build, // ikon mekanik (kunci inggris)
              title: 'Mekanik',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MechanicFormPage()),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.bolt, // ikon listrik (petir)
              title: 'Electric',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ElectricFormPage()),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.table_chart, // ikon matriks mekanik
              title: 'Mekanik 2',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MechanicMatrixPage()),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.grid_on, // ikon matriks elektrik
              title: 'Electric 2',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ElectricMatrixPage()),
                );
              },
            ),
            DashboardMenuItem(
              icon: Icons.list_alt, // ikon log (daftar)
              title: 'Log Gangguan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LogListPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
