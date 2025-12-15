import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checksheet_inventaris_page.dart';
import 'checksheet_gerbong_fase_page.dart';
import 'gangguan_form_page.dart';
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
          onTap: () {
            // ✅ Kembali ke Dashboard (halaman pertama)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
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
                      } else if (sheetName == 'Mekanik 2' ||
                          sheetName == 'Elektrik') {
                        //Navigate ke Gerbong Fase Page
                        Navigator.push(
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
                        // Show Coming Soon untuk Gangguan
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
          namaKategori: 'ALAT TOLAK TARIK',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Kopler Mekanik',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Selisih Tinggi Buffer',
              standar: 'Baik/Utuh',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Klaw dan Pen Klaw',
              standar: 'Baik',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'BOGIE & PERANGKATNYA',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Pegas Daun/ Primer/ Sekunder',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Bantalan Gandar/ Bearing Axlebox',
              standar: 'Baik/Utuh',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Penyangga Balk Ayun',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Balk Ayun / Bolster',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Gantungan Pengaman',
              standar: 'Lengkap, Baik/Utuh',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'f. Axle Box',
              standar: 'Baik/Tidak Bocor',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Sluistik dan Mur Baud Pengaman(Bogie K5)',
              standar: 'Lengkap',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'PENGEREMAN',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Tekanan Udara Pengereman',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Kebocoran Saluran Pengereman',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Kondisi Rem Blok',
              standar: 'Baik/Tidak Aus',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Stang Rem',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Control Valve ( Distributor Valve)',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'f. Slack Adjuster (Jurson)',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Sylinder Rem',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'h. Kondisi Triangle',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'i. Pengaman Triangle',
              standar: 'Berfungsi',
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
          ],
        ),
      ];
    } else if (_currentSheet == 'Genset') {
      _kategoriList = [
        ChecksheetKategoriModel(
          namaKategori: 'KONDISI GENSET AWAL',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Bocoran/ Tetesan Pelumas, air, HSD',
              standar: 'Tidak Ada',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. HSD didalam pipa ukur',
              standar: 'Cukup',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Air Pendingin pada gelas ukur',
              standar: 'Cukup',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Pelumas pada deep stick',
              standar: 'Cukup',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'MENGHIDUPKAN GENSET',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Tekanan Pelumas',
              standar: '2,5 - 6 Bar',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Tekanan air pendingin',
              standar: '2,5 - 6 Bar',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Tekanan bahan bakar',
              standar: '1,5 - 3 Bar',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Tegangan baterai',
              standar: '24 - 28 Volt',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Frekuensi genset tanpa beban',
              standar: '48 - 51 Hz',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'f. Tegangan genset tanpa beban',
              standar: '380 - 410 Volt',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Tekanan udara genset',
              standar: '2,5 - 6 Bar',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'h. Motor kipas radiator',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'i. Motor starter',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'j. Dinamo Pengisian',
              standar: 'Baik',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'MEMBEBANI GENSET',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Saklar Utama',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Panel Listrik',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Jam Pembebanan',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Frekuensi genset pada saat pembebanan',
              standar: '48 - 51 Hz',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Ampere',
              standar: 'Max. 10% antar fasa',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'MEMATIKAN GENSET',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Jam mematikan genset',
              standar: 'Terpantau',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Jam kerja genset setelah dimatikan',
              standar: 'Terpantau',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Suhu air pendingin',
              standar: '70 - 90 °C',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Kondisi tetesan pelumas, Air, HSD',
              standar: 'Tidak Ada',
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

  // Widget untuk render kategori
  Widget _buildKategoriSection(ChecksheetKategoriModel kategori) {
    // Deteksi kategori Catatan Penting
    final isCatatanPenting = kategori.namaKategori.toLowerCase().contains(
      'catatan penting',
    );

    // Jika Catatan Penting, render khusus (1x header + 1x TextField)
    if (isCatatanPenting) {
      return _buildCatatanPentingSection(kategori);
    }

    // Untuk kategori lainnya, render normal
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
          return _buildKomponenItem(
            entry.value,
            entry.key,
            kategori.namaKategori,
          );
        }).toList(),
      ],
    );
  }

  // ✅ Widget untuk item dengan input angka + satuan
  Widget _buildInputAngkaSatuanItem(ChecksheetKomponenModel item) {
    String nilaiInput = item.hasilInput;

    // Deteksi satuan dari standar
    String satuan = '';
    String labelInput = 'Inputkan Nilai';

    final standarLower = item.standar.toLowerCase();

    if (standarLower.contains('bar')) {
      satuan = 'Bar';
    } else if (standarLower.contains('volt')) {
      satuan = 'Volt';
    } else if (standarLower.contains('hz')) {
      satuan = 'Hz';
    } else if (standarLower.contains('°c')) {
      satuan = '°C';
    } else if (standarLower.contains('kg') || standarLower.contains('cm²')) {
      satuan = 'Kg/cm²';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
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

          // Standar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6.0),
              border: Border(
                bottom: BorderSide(color: const Color(0xFF2196F3), width: 2.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    item.standar,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2196F3),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Input dengan satuan
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: nilaiInput)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: nilaiInput.length),
                    ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: labelInput,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: Colors.grey[600],
                    ),
                    hintText: '0.0',
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
                    fontSize: 13.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    setState(() {
                      item.hasilInput = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  satuan,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            controller: TextEditingController(text: item.keterangan)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.keterangan.length),
              ),
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut (Opsional)',
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
            maxLines: 3,
            minLines: 1,
            onChanged: (value) {
              setState(() {
                item.keterangan = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ✅ Widget khusus untuk Ampere (3 fase: R, S, T)
  Widget _buildAmpereTripleFaseItem(ChecksheetKomponenModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color:
              (item.multiInput['R']?.isNotEmpty ?? false) ||
                      (item.multiInput['S']?.isNotEmpty ?? false) ||
                      (item.multiInput['T']?.isNotEmpty ?? false)
                  ? const Color(0xFF2196F3)
                  : Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // Standar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6.0),
              border: Border(
                bottom: BorderSide(color: const Color(0xFF2196F3), width: 2.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    item.standar,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2196F3),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // Input Ampere R
          _buildAmpereInputRow(
            label: 'Ampere R:',
            value: item.multiInput['R'] ?? '',
            onChanged: (value) {
              setState(() {
                item.multiInput['R'] = value;
              });
            },
          ),

          const SizedBox(height: 12.0),

          // Input Ampere S
          _buildAmpereInputRow(
            label: 'Ampere S:',
            value: item.multiInput['S'] ?? '',
            onChanged: (value) {
              setState(() {
                item.multiInput['S'] = value;
              });
            },
          ),

          const SizedBox(height: 12.0),

          // Input Ampere T
          _buildAmpereInputRow(
            label: 'Ampere T:',
            value: item.multiInput['T'] ?? '',
            onChanged: (value) {
              setState(() {
                item.multiInput['T'] = value;
              });
            },
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            controller: TextEditingController(text: item.keterangan)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.keterangan.length),
              ),
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut (Opsional)',
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
            maxLines: 3,
            minLines: 1,
            onChanged: (value) {
              setState(() {
                item.keterangan = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk input row Ampere
  Widget _buildAmpereInputRow({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 90.0,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: value.length),
              ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Nilai (A)',
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
              fontSize: 13.0,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            '(A)',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Widget untuk input waktu (Pukul: WIB atau JKM)
  Widget _buildWaktuInputItem(ChecksheetKomponenModel item) {
    String satuanWaktu = 'Pukul: WIB';
    String hintText = '00:00';
    TextInputType keyboardType = TextInputType.datetime;

    final itemLower = item.itemPemeriksaan.toLowerCase();

    if (itemLower.contains('jam kerja') || itemLower.contains('jkm')) {
      satuanWaktu = 'JKM';
      hintText = '0';
      keyboardType = const TextInputType.numberWithOptions(decimal: true);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
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

          // Standar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6.0),
              border: Border(
                bottom: BorderSide(color: const Color(0xFF2196F3), width: 2.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    item.standar,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2196F3),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Input Waktu
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: item.hasilInput)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: item.hasilInput.length),
                    ),
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    labelText: 'Inputkan Nilai Terpantau',
                    labelStyle: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: Colors.grey[600],
                    ),
                    hintText: hintText,
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
                    fontSize: 13.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    setState(() {
                      item.hasilInput = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  satuanWaktu,
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            controller: TextEditingController(text: item.keterangan)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.keterangan.length),
              ),
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut (Opsional)',
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
            maxLines: 3,
            minLines: 1,
            onChanged: (value) {
              setState(() {
                item.keterangan = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKomponenItem(
    ChecksheetKomponenModel item,
    int index,
    String kategoriName,
  ) {
    final standarLower = item.standar.toLowerCase();
    final itemLower = item.itemPemeriksaan.toLowerCase();

    // 1. Deteksi AMPERE (3 input: R, S, T)
    if (itemLower.contains('ampere') && standarLower.contains('fasa')) {
      return _buildAmpereTripleFaseItem(item);
    }

    // 2. Deteksi JAM/WAKTU (Pukul WIB atau JKM)
    if (itemLower.contains('jam') && standarLower.contains('terpantau')) {
      return _buildWaktuInputItem(item);
    }

    // 3. Deteksi input ANGKA + SATUAN (Bar, Volt, Hz, °C, Kg/cm²)
    final needsNumericInput =
        standarLower.contains('kg') ||
        standarLower.contains('cm²') ||
        standarLower.contains('bar') ||
        standarLower.contains('volt') ||
        standarLower.contains('hz') ||
        standarLower.contains('°c');

    if (needsNumericInput) {
      return _buildInputAngkaSatuanItem(item);
    }
    // 4. Deteksi BUTTON CHOICE (2 tombol)
    final usesButtonChoice =
        standarLower.contains('baik') ||
        standarLower.contains('lengkap') ||
        standarLower.contains('seimbang') ||
        standarLower.contains('berfungsi') ||
        standarLower.contains('tidak ada') ||
        standarLower.contains('cukup') ||
        standarLower.contains('bocor');

    if (usesButtonChoice) {
      return _buildButtonChoiceItem(item);
    }

    // 5. Default: Text Field standard
    return _buildStandardKomponenItem(item);
  }

  //Widget untuk item dengan pilihan button Baik/Rusak
  Widget _buildButtonChoiceItem(ChecksheetKomponenModel item) {
    // Parse hasil input: "BAIK" atau "RUSAK"
    final selectedChoice = item.hasilInput.toUpperCase();
    // ✅ Deteksi label button dari standar
    String leftButton = 'Baik';
    String rightButton = 'Rusak';

    final standarLower = item.standar.toLowerCase();

    if (standarLower.contains('tidak ada') && standarLower.contains('ada')) {
      leftButton = 'Tidak Ada';
      rightButton = 'Ada';
    } else if (standarLower.contains('cukup') &&
        standarLower.contains('kurang')) {
      leftButton = 'Cukup';
      rightButton = 'Kurang';
    } else if (standarLower.contains('seimbang') &&
        standarLower.contains('tidak')) {
      leftButton = 'Seimbang';
      rightButton = 'Tidak';
    } else if (standarLower.contains('lengkap') &&
        !standarLower.contains('baik')) {
      leftButton = 'Lengkap';
      rightButton = 'Tidak';
    } else if (standarLower.contains('lengkap') &&
        standarLower.contains('baik')) {
      leftButton = 'Lengkap dan Baik';
      rightButton = 'Tidak';
    } else if (standarLower.contains('berfungsi') &&
        standarLower.contains('tidak')) {
      leftButton = 'Berfungsi';
      rightButton = 'Tidak';
    } else if (standarLower.contains('berfungsi')) {
      leftButton = 'Berfungsi';
      rightButton = 'Rusak';
    } else if (standarLower.contains('bocor') &&
        standarLower.contains('tidak')) {
      leftButton = 'Tidak';
      rightButton = 'Bocor';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
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

          // Standar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6.0),
              border: Border(
                bottom: BorderSide(color: const Color(0xFF2196F3), width: 2.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    item.standar,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2196F3),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Tombol Pilihan
          Row(
            children: [
              Expanded(
                child: _buildKondisiButton(
                  label: leftButton,
                  isSelected:
                      selectedChoice ==
                      leftButton.toUpperCase().replaceAll(' ', '_'),
                  onTap: () {
                    setState(() {
                      item.hasilInput = leftButton.toUpperCase().replaceAll(
                        ' ',
                        '_',
                      );
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildKondisiButton(
                  label: rightButton,
                  isSelected:
                      selectedChoice ==
                      rightButton.toUpperCase().replaceAll(' ', '_'),
                  onTap: () {
                    setState(() {
                      item.hasilInput = rightButton.toUpperCase().replaceAll(
                        ' ',
                        '_',
                      );
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            controller: TextEditingController(text: item.keterangan)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.keterangan.length),
              ),
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut (Opsional)',
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
            maxLines: 3,
            minLines: 1,
            onChanged: (value) {
              setState(() {
                item.keterangan = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ✅ Widget khusus untuk section Catatan Penting (1 header + 1 TextField)
  Widget _buildCatatanPentingSection(ChecksheetKategoriModel kategori) {
    // Ambil item pertama sebagai representasi catatan penting
    final item =
        kategori.items.isNotEmpty
            ? kategori.items[0]
            : ChecksheetKomponenModel(
              itemPemeriksaan: 'Catatan Penting',
              standar: 'Catatan',
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header "Catatan Penting" di luar container
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
          child: Text(
            'Catatan Penting',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2196F3),
              height: 1.4,
            ),
          ),
        ),

        // TextField untuk catatan penting (hanya 1)
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: TextField(
            controller: TextEditingController(text: item.hasilInput)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.hasilInput.length),
              ),
            decoration: InputDecoration(
              hintText: 'Catatan Penting',
              hintStyle: GoogleFonts.inter(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              filled: true,
              fillColor: Colors.white,
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
            maxLines: 6,
            minLines: 4,
            onChanged: (value) {
              setState(() {
                item.hasilInput = value;
              });
            },
          ),
        ),
      ],
    );
  }

  //Widget untuk item standard
  Widget _buildStandardKomponenItem(ChecksheetKomponenModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
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
          // ✅ Standar (full width dengan format: "Standar: Baik")
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Light blue background
              borderRadius: BorderRadius.circular(6.0),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF2196F3), // Blue underline
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const Spacer(),
                Text(
                  item.standar,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // ✅ Hasil Input (Editable) - Full Width
          TextField(
            controller: TextEditingController(text: item.hasilInput)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.hasilInput.length),
              ),
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
            style: GoogleFonts.inter(fontSize: 12.0, color: Colors.black87),
            onChanged: (value) {
              setState(() {
                item.hasilInput = value;
              });
            },
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            controller: TextEditingController(text: item.keterangan)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.keterangan.length),
              ),
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut (Opsional)',
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
              setState(() {
                item.keterangan = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Widget khusus untuk Tekanan Udara Pengereman
  Widget _buildTekananUdaraItem(ChecksheetKomponenModel item) {
    // Parse nilai dari hasilInput (format: "5|BAIK" atau "4.8|RUSAK")
    final parts = item.hasilInput.split('|');
    String nilaiTekanan =
        parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : '';
    String statusKondisi = parts.length > 1 ? parts[1] : '';

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
          // ✅ Nama item
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

          // ✅ Standar (full width dengan format: "Standar:  Baik")
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Light blue background
              borderRadius: BorderRadius.circular(6.0),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF2196F3), // Blue underline
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const Spacer(),
                Text(
                  item.standar,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Input Nilai dengan satuan Kg/cm²
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: nilaiTekanan)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: nilaiTekanan.length),
                    ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Inputkan Nilai',
                    labelStyle: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: Colors.grey[600],
                    ),
                    hintText: '0.0',
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
                    fontSize: 13.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    setState(() {
                      nilaiTekanan = value;
                      item.hasilInput = '$value|$statusKondisi';
                    });
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              // Label satuan
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Kg/cm²',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Tombol Baik / Rusak
          Row(
            children: [
              Expanded(
                child: _buildKondisiButton(
                  label: 'Baik',
                  isSelected: statusKondisi == 'BAIK',
                  onTap: () {
                    setState(() {
                      statusKondisi = 'BAIK';
                      item.hasilInput = '$nilaiTekanan|BAIK';
                    });
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildKondisiButton(
                  label: 'Rusak',
                  isSelected: statusKondisi == 'RUSAK',
                  onTap: () {
                    setState(() {
                      statusKondisi = 'RUSAK';
                      item.hasilInput = '$nilaiTekanan|RUSAK';
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Keterangan
          TextField(
            controller: TextEditingController(text: item.keterangan)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.keterangan.length),
              ),
            decoration: InputDecoration(
              hintText: 'Keterangan/Tindak Lanjut (Opsional)',
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
              setState(() {
                item.keterangan = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk tombol Baik/Rusak
  Widget _buildKondisiButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
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

  //Widget untuk Catatan Penting
  Widget _buildCatatanPentingItem(ChecksheetKomponenModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header "Catatan Penting" di luar container
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 0.0),
          child: Text(
            'Catatan Penting',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2196F3),
              height: 1.4,
            ),
          ),
        ),

        // TextField untuk catatan penting
        Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: TextField(
            controller: TextEditingController(text: item.hasilInput)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: item.hasilInput.length),
              ),
            decoration: InputDecoration(
              hintText: 'Catatan Penting',
              hintStyle: GoogleFonts.inter(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              filled: true,
              fillColor: Colors.white,
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
            maxLines: 6,
            minLines: 4,
            onChanged: (value) {
              setState(() {
                item.hasilInput = value;
              });
            },
          ),
        ),
      ],
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
