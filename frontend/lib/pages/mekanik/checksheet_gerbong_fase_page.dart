import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../models/jadwal_model.dart';
import '../../models/checksheet_gerbong_fase_model.dart';
import 'checksheet_mekanik2_elektrik_page.dart';
import 'checksheet_inventaris_page.dart';
import 'checksheet_komponen_page.dart';
import 'gangguan_form_page.dart';

class ChecksheetGerbongFasePage extends StatefulWidget {
  final User user;
  final JadwalModel jadwal;
  final int laporanId;
  final String sheetType; // 'Mekanik 2' atau 'Elektrik'

  const ChecksheetGerbongFasePage({
    Key? key,
    required this.user,
    required this.jadwal,
    required this.laporanId,
    required this.sheetType,
  }) : super(key: key);

  @override
  State<ChecksheetGerbongFasePage> createState() =>
      _ChecksheetGerbongFasePageState();
}

class _ChecksheetGerbongFasePageState extends State<ChecksheetGerbongFasePage> {
  final _formKey = GlobalKey<FormState>();
  final ChecksheetGerbongFaseModel _gerbongFaseData =
      ChecksheetGerbongFaseModel();

  final TextEditingController _nomorGerbongController = TextEditingController();

  // ✅ Scroll Controllers
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();

  // ✅ State untuk scroll indicators
  bool _showBackToTop = false;
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  double _scrollProgress = 0.0;

  // ✅ Sheet tabs data
  final List<Map<String, dynamic>> _sheets = [
    {'name': 'Tool Box', 'icon': Icons.construction},
    {'name': 'Tool Kit', 'icon': Icons.build},
    {'name': 'Mekanik', 'icon': Icons.engineering},
    {'name': 'Genset', 'icon': Icons.electrical_services},
    {'name': 'Mekanik 2', 'icon': Icons.settings},
    {'name': 'Elektrik', 'icon': Icons.bolt},
    {'name': 'Gangguan', 'icon': Icons.warning},
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Add listener untuk horizontal scroll indicator
    _scrollController.addListener(_updateScrollArrows);

    // ✅ Add listener untuk back to top button
    _listScrollController.addListener(() {
      if (_listScrollController.hasClients) {
        final showButton = _listScrollController.offset > 200;
        if (showButton != _showBackToTop) {
          setState(() {
            _showBackToTop = showButton;
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollArrows());
  }

  @override
  void dispose() {
    _nomorGerbongController.dispose();
    _scrollController.removeListener(_updateScrollArrows);
    _scrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  // ✅ Update scroll arrows
  void _updateScrollArrows() {
    if (!mounted || !_scrollController.hasClients) return;

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;

    setState(() {
      _showLeftArrow = currentScroll > 0;
      _showRightArrow = currentScroll < maxScroll;

      if (maxScroll > 0) {
        _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      } else {
        _scrollProgress = 0.0;
      }
    });
  }

  // ✅ Scroll tabs by offset
  void _scrollTabsBy(double offset) {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final target = (position.pixels + offset).clamp(
      0.0,
      position.maxScrollExtent,
    );

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  // ✅ Scroll to top
  void _scrollToTop() {
    _listScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C2A6B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo_putih.png',
                height: 40,
                width: 80,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 40,
                    width: 80,
                    color: Colors.white.withOpacity(0.2),
                    child: Center(
                      child: Text(
                        'KAI',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 18.0,
                  backgroundImage:
                      widget.user.photoUrl != null
                          ? NetworkImage(widget.user.photoUrl!)
                          : null,
                  backgroundColor: const Color(0xFF2C2A6B).withOpacity(0.1),
                  child:
                      widget.user.photoUrl == null
                          ? Text(
                            _getInitials(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2A6B),
                            ),
                          )
                          : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            // ✅ Kembali ke Dashboard (halaman pertama)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back,
                color: Color(0xFF0063F7),
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Kembali ke Dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0063F7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaporanInfoCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.jadwal.noKa} - ${widget.jadwal.namaKa}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          const TextSpan(
                            text: 'GMR-SMT',
                            style: TextStyle(
                              color: Color(0xFF0063F7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' | ID: #${widget.laporanId}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 16.0,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Baru',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Sheet Tabs dengan scroll indicator
  Widget _buildSheetTabs() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: Column(
        children: [
          ClipRect(
            child: SizedBox(
              height: 50.0,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification ||
                      notification is OverscrollNotification ||
                      notification is ScrollEndNotification) {
                    _updateScrollArrows();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  itemCount: _sheets.length,
                  itemBuilder: (context, index) {
                    final sheet = _sheets[index];
                    final isSelected = sheet['name'] == widget.sheetType;

                    return GestureDetector(
                      onTap: () {
                        final sheetName = sheet['name'] as String;

                        final currentScrollPosition =
                            _scrollController.hasClients
                                ? _scrollController.offset
                                : 0.0;

                        // ✅ Navigasi berdasarkan tipe sheet
                        if (sheetName == 'Tool Box' ||
                            sheetName == 'Tool Kit') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChecksheetInventarisPage(
                                    user: widget.user,
                                    jadwal: widget.jadwal,
                                    laporanId: widget.laporanId,
                                  ),
                            ),
                          );
                        } else if (sheetName == 'Mekanik' ||
                            sheetName == 'Genset') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChecksheetKomponenPage(
                                    user: widget.user,
                                    jadwal: widget.jadwal,
                                    laporanId: widget.laporanId,
                                    initialSheet: sheetName,
                                  ),
                            ),
                          );
                        } else if (sheetName == 'Mekanik 2' ||
                            sheetName == 'Elektrik') {
                          if (sheetName == widget.sheetType) {
                            return;
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChecksheetGerbongFasePage(
                                    user: widget.user,
                                    jadwal: widget.jadwal,
                                    laporanId: widget.laporanId,
                                    sheetType: sheetName,
                                  ),
                            ),
                          );
                        } else if (sheetName == 'Gangguan') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => GangguanFormPage(
                                    user: widget.user,
                                    jadwal: widget.jadwal,
                                    laporanId: widget.laporanId,
                                  ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        constraints: const BoxConstraints(minWidth: 110.0),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF2196F3)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              sheet['icon'],
                              size: 18.0,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              sheet['name'],
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          _buildScrollIndicator(),
        ],
      ),
    );
  }

  // ✅ Scroll Indicator
  Widget _buildScrollIndicator() {
    if (!_scrollController.hasClients) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            _buildIndicatorArrow(isLeft: true, enabled: false, onTap: () {}),
            const SizedBox(width: 8.0),
            Expanded(
              child: Container(
                height: 6.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            _buildIndicatorArrow(isLeft: false, enabled: false, onTap: () {}),
          ],
        ),
      );
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll == 0) {
      return const SizedBox.shrink();
    }

    final double viewportWidth = _scrollController.position.viewportDimension;
    final double totalContentWidth = maxScroll + viewportWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildIndicatorArrow(
            isLeft: true,
            enabled: _showLeftArrow,
            onTap: () => _scrollTabsBy(-viewportWidth * 0.8),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double trackWidth = constraints.maxWidth;
                final double indicatorWidth =
                    ((viewportWidth / totalContentWidth) * trackWidth).clamp(
                      32.0,
                      trackWidth,
                    );

                final double scrollRatio = _scrollProgress;
                final double maxIndicatorPosition = trackWidth - indicatorWidth;
                final double indicatorLeft = (maxIndicatorPosition *
                        scrollRatio)
                    .clamp(0.0, maxIndicatorPosition);

                return SizedBox(
                  height: 12.0,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      Positioned(
                        left: indicatorLeft,
                        child: Container(
                          height: 5.0,
                          width: indicatorWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFFABAAC4),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          _buildIndicatorArrow(
            isLeft: false,
            enabled: _showRightArrow,
            onTap: () => _scrollTabsBy(viewportWidth * 0.8),
          ),
        ],
      ),
    );
  }

  // ✅ Indicator Arrow
  Widget _buildIndicatorArrow({
    required bool isLeft,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          isLeft ? Icons.chevron_left : Icons.chevron_right,
          size: 20.0,
          color: enabled ? const Color(0xFF7B83EB) : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    widget.sheetType == 'Mekanik 2'
                        ? Icons.settings
                        : Icons.bolt,
                    color: const Color(0xFF2196F3),
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    '${widget.sheetType} Checksheet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Status: Tersimpan',
              style: GoogleFonts.inter(fontSize: 12.0, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20.0),

            // Section: Pilih Gerbong dan Fase
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PILIH GERBONG DAN FASE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // a. Nomor Gerbong/Stamformasi
            Text(
              'a. Nomor Gerbong/Stamformasi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _nomorGerbongController,
              decoration: InputDecoration(
                hintText: 'Contoh: K1-15101',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.0,
                  color: Colors.grey[400],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              style: GoogleFonts.inter(fontSize: 14.0, color: Colors.black87),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor Gerbong harus diisi';
                }
                return null;
              },
              onChanged: (value) {
                _gerbongFaseData.nomorGerbong = value;
              },
            ),
            const SizedBox(height: 20.0),

            // b. Pilih Fase
            Text(
              'b. Pilih Fase',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12.0),

            // Fase Berangkat (B)
            Row(
              children: [
                Expanded(
                  child: _buildFaseButton(
                    label: 'Fase Berangkat (B)',
                    isSelected: _gerbongFaseData.faseBerangkat == 'B',
                    onTap: () {
                      setState(() {
                        _gerbongFaseData.faseBerangkat = 'B';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12.0),

                // Fase Kembali (K)
                Expanded(
                  child: _buildFaseButton(
                    label: 'Fase Kembali (K)',
                    isSelected: _gerbongFaseData.faseKembali == 'K',
                    onTap: () {
                      setState(() {
                        _gerbongFaseData.faseKembali = 'K';
                      });
                    },
                  ),
                ),
              ],
            ),

            // Validator untuk Fase
            if (_formKey.currentState != null &&
                _gerbongFaseData.faseBerangkat.isEmpty &&
                _gerbongFaseData.faseKembali.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Minimal pilih salah satu fase',
                  style: GoogleFonts.inter(fontSize: 12.0, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaseButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMulaiLaporanButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() &&
              (_gerbongFaseData.faseBerangkat.isNotEmpty ||
                  _gerbongFaseData.faseKembali.isNotEmpty)) {
            // Navigate ke checksheet page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ChecksheetMekanik2ElektrikPage(
                      user: widget.user,
                      jadwal: widget.jadwal,
                      laporanId: widget.laporanId,
                      sheetType: widget.sheetType,
                      gerbongFaseData: _gerbongFaseData,
                    ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Harap lengkapi semua field dan pilih minimal 1 fase',
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
        ),
        child: Text(
          'Mulai Laporan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (widget.user.nama == null || widget.user.nama!.isEmpty) {
      return 'M';
    }

    final parts = widget.user.nama!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return widget.user.nama!.substring(0, 1).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Ganti dari Colors.grey.shade50
      body: Column(
        children: [
          _buildCustomHeader(),
          _buildBackButton(),
          _buildLaporanInfoCard(),
          _buildSheetTabs(), // ✅ TAMBAHKAN INI
          Expanded(
            child: ListView(
              controller: _listScrollController, // ✅ TAMBAHKAN INI
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              children: [
                const SizedBox(height: 16.0),
                _buildFormSection(),
                _buildMulaiLaporanButton(),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ],
      ),
      // ✅ TAMBAHKAN FLOATING ACTION BUTTON
      floatingActionButton:
          _showBackToTop
              ? FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: const Color(0xFF2196F3),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
              : null,
    );
  }
}
