import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checksheet_komponen_page.dart';
import 'checksheet_gerbong_fase_page.dart';
import 'gangguan_form_page.dart';
import '../../models/user_model.dart';
import '../../models/jadwal_model.dart';
import '../../models/checksheet_item_model.dart';
import '../../services/checksheet_service.dart';
import '../common/success_page.dart';
import '../common/error_page.dart';

class ChecksheetInventarisPage extends StatefulWidget {
  final User user;
  final JadwalModel jadwal;
  final int laporanId;

  const ChecksheetInventarisPage({
    Key? key,
    required this.user,
    required this.jadwal,
    required this.laporanId,
  }) : super(key: key);

  @override
  State<ChecksheetInventarisPage> createState() =>
      _ChecksheetInventarisPageState();
}

class _ChecksheetInventarisPageState extends State<ChecksheetInventarisPage> {
  bool _isLoading = false;
  String _currentSheet = 'Tool Box';

  // ✅ Controller untuk tab horizontal scroll
  final ScrollController _scrollController = ScrollController();

  // ✅ Controller untuk list vertical scroll
  final ScrollController _listScrollController = ScrollController();

  // ✅ State variables
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

  late List<ChecksheetItemModel> _toolBoxItems;

  @override
  void initState() {
    super.initState();
    _initializeToolBoxItems();

    // ✅ Listener untuk horizontal tab scroll
    _scrollController.addListener(_updateScrollArrows);

    // ✅ Listener untuk vertical list scroll (untuk FAB)
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

  void _initializeToolBoxItems() {
    if (_currentSheet == 'Tool Box') {
      _toolBoxItems = [
        ChecksheetItemModel(
          itemPemeriksaan: '1. Semboyan 21 Portable',
          jumlah: '1 Set',
        ),
        ChecksheetItemModel(itemPemeriksaan: '2. Palu', jumlah: '1 Bh'),
        ChecksheetItemModel(
          itemPemeriksaan: '3. Linggis kecil',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '4. Selang air brake',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(itemPemeriksaan: '5. V-belt', jumlah: '1 Bh'),
        ChecksheetItemModel(itemPemeriksaan: '6. Jas hujan', jumlah: '1 Bh'),
        ChecksheetItemModel(itemPemeriksaan: '7. Rem blok', jumlah: '1 Bh'),
        ChecksheetItemModel(itemPemeriksaan: '8. Kawat', jumlah: '1 Bh'),
        ChecksheetItemModel(itemPemeriksaan: '9. Stop block', jumlah: '4 Bh'),
        ChecksheetItemModel(itemPemeriksaan: '10. Kain lap', jumlah: '1 Bh'),
        ChecksheetItemModel(
          itemPemeriksaan: '11. Bandara putih',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '12. Bandara merah',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '13. Kabel 1 meter NYAF, NYHY θ 2,5mm',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '14. Lampu LED S.21',
          jumlah: '2 Bh',
        ),
        ChecksheetItemModel(itemPemeriksaan: '15. WD-40', jumlah: '1 Bh'),
        ChecksheetItemModel(
          itemPemeriksaan: '16. Sarung tangan',
          jumlah: '1 Set',
        ),
        ChecksheetItemModel(itemPemeriksaan: '17. Kran air', jumlah: '1 Bh'),
      ];
    } else if (_currentSheet == 'Tool Kit') {
      _toolBoxItems = [
        ChecksheetItemModel(
          itemPemeriksaan: '1. Kunci pas ring uk. 8 - 32 mm',
          jumlah: '1 Set',
        ),
        ChecksheetItemModel(itemPemeriksaan: '2. Kunci pipa', jumlah: '1 Bh'),
        ChecksheetItemModel(
          itemPemeriksaan: '3. Kunci Inggris',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '4. Kunci T13, 17, 19',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '5. Tang kombinasi',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(itemPemeriksaan: '6. Mur baud', jumlah: '5 Bh'),
        ChecksheetItemModel(itemPemeriksaan: '7. Clyton ring', jumlah: '3 Set'),
        ChecksheetItemModel(
          itemPemeriksaan: '8. Obeng plus dan minus',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(itemPemeriksaan: '9. Tang ampere', jumlah: '4 Bh'),
        ChecksheetItemModel(
          itemPemeriksaan: '10. Thermo digital / minitemp',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '11. Bener / Pahat',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '12. Isolasi bening, hitam',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(itemPemeriksaan: '13. Avo meter', jumlah: '1 Bh'),
        ChecksheetItemModel(
          itemPemeriksaan: '14. Senter charging',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(
          itemPemeriksaan: '15. Remote AC lengkap',
          jumlah: '1 Bh',
        ),
        ChecksheetItemModel(itemPemeriksaan: '16. Tespen', jumlah: '1 Bh'),
      ];
    } else if (_currentSheet == 'Mekanik' || _currentSheet == 'Genset') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChecksheetKomponenPage(
                  user: widget.user,
                  jadwal: widget.jadwal,
                  laporanId: widget.laporanId,
                  initialSheet: _currentSheet,
                ),
          ),
        );
      });
      _toolBoxItems = []; // Temporary empty
    } else {
      _toolBoxItems = [
        ChecksheetItemModel(
          itemPemeriksaan: '1. Item default untuk $_currentSheet',
          jumlah: '1 Brg',
        ),
      ];
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
              controller:
                  _listScrollController, // ✅ Penting: Tambahkan controller
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              children: [
                ..._toolBoxItems.asMap().entries.map((entry) {
                  return _buildChecklistItem(entry.value, entry.key);
                }).toList(),

                const SizedBox(height: 4.0),
                _buildBottomButton(),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
      // ✅ Floating Action Button
      floatingActionButton:
          _showBackToTop
              ? FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: const Color(0xFF2196F3),
                mini: false, // ✅ Ukuran normal
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
              : null,
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

                      // ✅ UPDATE: Navigasi berdasarkan tipe sheet
                      if (sheetName == 'Mekanik' || sheetName == 'Genset') {
                        // Navigasi ke ChecksheetKomponenPage
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
                      } else if (sheetName == 'Tool Box' ||
                          sheetName == 'Tool Kit') {
                        // Update state di page ini
                        setState(() {
                          _currentSheet = sheetName;
                          _initializeToolBoxItems();
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_listScrollController.hasClients) {
                            _listScrollController.jumpTo(0);
                          }
                        });
                      } else if (sheetName == 'Mekanik 2' ||
                          sheetName == 'Elektrik') {
                        // ✅ TAMBAHKAN INI: Navigate ke Gerbong Fase Page
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
                        // Untuk sheet lainnya
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

  Widget _buildSheetTitle() {
    final completedCount =
        _toolBoxItems.where((item) => item.hasilInput.isNotEmpty).length;
    final totalCount = _toolBoxItems.length;

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
            '$_currentSheet Checksheet (Inventaris)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            '$completedCount/$totalCount',
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

  Widget _buildChecklistItem(ChecksheetItemModel item, int index) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.itemPemeriksaan,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                'JML: ${item.jumlah}',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              _buildRadioButton(item, 'Baik'),
              const SizedBox(width: 8.0),
              _buildRadioButton(item, 'Rusak'),
              const SizedBox(width: 8.0),
              _buildRadioButton(item, 'Tidak ada'),
            ],
          ),
          const SizedBox(height: 12.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Keterangan(Opsional)',
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
            minLines: 2,
            onChanged: (value) {
              item.keterangan = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(ChecksheetItemModel item, String label) {
    final isSelected = item.hasilInput.toUpperCase() == label.toUpperCase();

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            item.hasilInput = label.toUpperCase();
          });
        },
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0063F7) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color:
                  isSelected ? const Color(0xFF0063F7) : Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    final allFilled = _toolBoxItems.every((item) => item.hasilInput.isNotEmpty);

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

  // ✅ Method untuk scroll ke atas
  void _scrollToTop() {
    if (_listScrollController.hasClients) {
      _listScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSimpan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ChecksheetService.simpanDataInventaris(
        laporanId: widget.laporanId,
        token: widget.user.token ?? '',
        namaSheet: _currentSheet,
        items: _toolBoxItems,
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
}
