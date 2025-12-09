import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checksheet_inventaris_page.dart';
import '../../models/user_model.dart';
import '../../models/jadwal_model.dart';
import '../../models/checksheet_komponen_model.dart';
import '../../models/checksheet_kategori_model.dart';
import '../../services/checksheet_service.dart';
import '../common/success_page.dart';
import '../common/error_page.dart';

class ChecksheetKomponenPage extends StatefulWidget {
  final User user;
  final JadwalModel jadwal;
  final int laporanId;
  final String initialSheet;

  const ChecksheetKomponenPage({
    Key? key,
    required this.user,
    required this.jadwal,
    required this.laporanId,
    this.initialSheet = 'Mekanik',
  }) : super(key: key);

  @override
  State<ChecksheetKomponenPage> createState() => _ChecksheetKomponenPageState();
}

class _ChecksheetKomponenPageState extends State<ChecksheetKomponenPage> {
  bool _isLoading = false;
  late String _currentSheet;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();
  bool _showBackToTop = false;
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  double _scrollProgress = 0.0;

  final List<Map<String, dynamic>> _sheets = [
    {'name': 'Tool Box', 'icon': Icons.construction},
    {'name': 'Tool Kit', 'icon': Icons.build},
    {'name': 'Mekanik', 'icon': Icons.engineering},
    {'name': 'Genset', 'icon': Icons.electrical_services},
    {'name': 'Mekanik 2', 'icon': Icons.settings},
    {'name': 'Elektrik', 'icon': Icons.bolt},
    {'name': 'Gangguan', 'icon': Icons.warning},
  ];

  late List<ChecksheetKategoriModel> _kategoriList;

  @override
  void initState() {
    super.initState();
    _currentSheet = widget.initialSheet;
    _initializeKategoriData();

    _scrollController.addListener(_updateScrollArrows);
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollArrows();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollArrows);
    _scrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

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
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back,
                color: const Color(0xFF0063F7),
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
                          TextSpan(
                            text: 'GMR-SMT',
                            style: TextStyle(
                              color: const Color(0xFF0063F7),
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
                      'Draft',
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
          const SizedBox(height: 12.0),
          Divider(color: Colors.grey.shade200, height: 1.0),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Icon(Icons.access_time, size: 14.0, color: Colors.grey[600]),
              const SizedBox(width: 6.0),
              Text(
                'Berangkat: ${widget.jadwal.jamBerangkat}',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          SizedBox(
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
                  final isSelected = _currentSheet == sheet['name'];

                  return GestureDetector(
                    onTap: () {
                      final sheetName = sheet['name'] as String;

                      // ✅ Navigasi ke page yang sesuai
                      if (sheetName == 'Tool Box' || sheetName == 'Tool Kit') {
                        // Kembali ke ChecksheetInventarisPage
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
                        // Stay di ChecksheetKomponenPage, update sheet
                        setState(() {
                          _currentSheet = sheetName;
                          _initializeKategoriData();
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_listScrollController.hasClients) {
                            _listScrollController.jumpTo(0);
                          }
                        });
                      } else {
                        // Untuk sheet lainnya (Mekanik 2, Elektrik, Gangguan)
                        // Bisa redirect ke page berbeda atau show coming soon
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$sheetName belum tersedia'),
                            duration: const Duration(seconds: 2),
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
                            color: isSelected ? Colors.white : Colors.grey[700],
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
                                  isSelected ? Colors.white : Colors.grey[700],
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
          const SizedBox(height: 1.0),
          _buildScrollIndicator(),
        ],
      ),
    );
  }

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

    if (maxScroll <= 0) {
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

  void _initializeKategoriData() {
    if (_listScrollController.hasClients) {
      _listScrollController.jumpTo(0);
    }

    if (_currentSheet == 'Mekanik') {
      _kategoriList = [
        ChecksheetKategoriModel(
          namaKategori: 'ALAT KOPLING TARIK',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: '1. Kopler Mekanik',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: '2. Kabel Tiang Otot',
              standar: 'Baik/Utuh',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: '3. Rantai Penarik Kait',
              standar: 'Baik',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'BOGIE & PERANGKATNYA',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Pegas Daun / Primary Suspension',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Bantalan Dimper/ Spring Anchor',
              standar: 'Baik/Utuh',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Pergerakan Balok Ayun',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Bak Rami / Beaker',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Kebersihan Perangkat',
              standar: 'Lengkap, Baik/Utuh',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'RODA & GANDARNYA',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Roda Akhir / Beaker',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Body Rami / Beaker',
              standar: 'Baik',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'PEMERIKSAAN',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Kebersihan/ Penampungan',
              standar: 'Bersih',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Semua',
              standar: 'Min. 4 Kg/ cm² atau sesuai SIK',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Kondisi Ban Blok',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Rem-Gantingan',
              standar: 'Baik/ Lengkap',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'CATATAN PENTING',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Kereta/GAS',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Listrik',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. No AC/Kompresor',
              standar: '3 Unit (HP)',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Indikasi pintu-pintu',
              standar: 'Baik/lengkap dan berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Anjuran',
              standar: 'Min. 2 Kg/ cm²',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'HIDRAULIK BRAKE',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Cylinder/ Distributor Wheel',
              standar: 'Baik/Tidak Bocor',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Slang/ piping/ Fitting',
              standar: 'Baik/Tidak Bocor',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Block Aplikasi cylinder (Jika ada)',
              standar: 'Tidak Retak dan Aus',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Accul (Indikator vert. 13)',
              standar: 'Baik/Tidak',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'PENGARAH BRACKET',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Kondisi gerakan-slinder, piston dll',
              standar: 'Baik (Tidak macet & lancar)',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Kondisi gerakan slinder piston',
              standar: 'Baik (Tidak Bocor)',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Brake slinding piston (10)',
              standar: 'Baik (Tidak Bocor)',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'INTERIOR/CEILING',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Interior/Ceiling (Normal)',
              standar: 'Baik/Normal',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Tempat/Jalur',
              standar: 'Bersih',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'PENANGKAL GUNCANG',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Penangkal Stickon',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Penangkal',
              standar: 'Terpasang',
            ),
          ],
        ),
      ];
    } else if (_currentSheet == 'Genset') {
      _kategoriList = [
        ChecksheetKategoriModel(
          namaKategori: 'PEMERIKSAAN',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Kebersihan/Penampungan',
              standar: 'Bersih',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Sumber',
              standar: 'Min. 4 Kg/ cm² atau sesuai SIK',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Kondisi Ban Blok',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Kunci Palu',
              standar: 'Baik/Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Dinding-panel (Tidak bocor, tambahan)',
              standar: 'Baik/Utuh (Tidak ada tetes/kebocoran)',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'PENGECEKAN ON/OFF',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Genset On',
              standar: 'On/Normal',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Genset Off',
              standar: 'Off/Tidak Berjalan',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'CATATAN PENTING',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'Catatan Penting',
              standar: 'Pastikan genset dalam kondisi baik',
            ),
          ],
        ),
      ];
    } else {
      _kategoriList = [];
    }
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

  int _getTotalItems() {
    return _kategoriList.fold(0, (sum, kat) => sum + kat.items.length);
  }

  int _getCompletedItems() {
    return _kategoriList.fold(
      0,
      (sum, kat) =>
          sum + kat.items.where((item) => item.hasilInput.isNotEmpty).length,
    );
  }

  List<ChecksheetKomponenModel> _getAllItems() {
    final allItems = <ChecksheetKomponenModel>[];
    for (var kategori in _kategoriList) {
      allItems.addAll(kategori.items);
    }
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildCustomHeader(),
          _buildBackButton(),
          _buildLaporanInfoCard(),
          _buildSheetTabs(),
          _buildSheetTitle(),

          Expanded(
            child: ListView(
              controller: _listScrollController,
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              children: [
                // Render per kategori
                ..._kategoriList.map((kategori) {
                  return _buildKategoriSection(kategori);
                }).toList(),

                const SizedBox(height: 4.0),
                _buildBottomButton(),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
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

  // ✅ Widget untuk render kategori
  Widget _buildKategoriSection(ChecksheetKategoriModel kategori) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header kategori
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
          ),
          child: Text(
            kategori.namaKategori,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2196F3),
            ),
          ),
        ),

        // Items dalam kategori
        ...kategori.items.asMap().entries.map((entry) {
          return _buildKomponenItem(entry.value, entry.key);
        }).toList(),
      ],
    );
  }

  // ✅ Widget untuk item komponen (dengan Standar & Hasil Input)
  Widget _buildKomponenItem(ChecksheetKomponenModel item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color:
              item.hasilInput.isEmpty
                  ? Colors.grey.shade300
                  : const Color(0xFF2196F3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama item
          Text(
            item.itemPemeriksaan,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12.0),

          // Row: Standar & Hasil Input
          Row(
            children: [
              // Standar (Read-only)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standar',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        item.standar,
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),

              // Hasil Input (Editable)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Isi hasil...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 10.0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF2196F3),
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        setState(() {
                          item.hasilInput = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut(Opsional)',
              hintStyle: GoogleFonts.inter(
                fontSize: 12.0,
                color: Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
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
            ),
            style: GoogleFonts.inter(fontSize: 13.0, color: Colors.black87),
            maxLines: 2,
            minLines: 1,
            onChanged: (value) {
              item.keterangan = value;
            },
          ),
        ],
      ),
    );
  }

  // Widget lainnya sama seperti ChecksheetInventarisPage
  // _buildCustomHeader(), _buildBackButton(), _buildLaporanInfoCard(), dll.
  // Copy dari ChecksheetInventarisPage

  Widget _buildBottomButton() {
    final allItems = _getAllItems();
    final allFilled = allItems.every((item) => item.hasilInput.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: allFilled && !_isLoading ? _handleSimpan : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child:
            _isLoading
                ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  'Simpan $_currentSheet',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
      ),
    );
  }

  void _handleSimpan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allItems = _getAllItems();

      final result = await ChecksheetService.simpanDataKomponen(
        laporanId: widget.laporanId,
        token: widget.user.token ?? '',
        namaSheet: _currentSheet,
        items: allItems,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => SuccessPage(
                  message: result['message'] ?? 'Data berhasil disimpan',
                  onBackPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ErrorPage(
                  message: e.toString().replaceAll('Exception: ', ''),
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        );
      }
    }
  }

  void _scrollToTop() {
    _listScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSheetTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$_currentSheet Checksheet (Komponen)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            '${_getCompletedItems()}/${_getTotalItems()}',
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Copy widget lainnya dari ChecksheetInventarisPage:
  // - _buildCustomHeader()
  // - _buildBackButton()
  // - _buildLaporanInfoCard()
  // - _buildSheetTabs()
  // - _buildScrollIndicator()
  // - _buildIndicatorArrow()
}
