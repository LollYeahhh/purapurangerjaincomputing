import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../models/checksheet_review_model.dart';
import '../../services/pengawas_checksheet_service.dart';
import '../../config/app_config.dart';
import '../../utils/mock_checksheet_data.dart';

class ChecksheetInventarisReviewPage extends StatefulWidget {
  final User user;
  final int laporanId;
  final String? noKa;
  final String? namaKa;
  final String? namaMekanik;
  final String? submittedAt;

  const ChecksheetInventarisReviewPage({
    Key? key,
    required this.user,
    required this.laporanId,
    this.noKa,
    this.namaKa,
    this.namaMekanik,
    this.submittedAt,
  }) : super(key: key);

  @override
  State<ChecksheetInventarisReviewPage> createState() =>
      _ChecksheetInventarisReviewPageState();
}

class _ChecksheetInventarisReviewPageState
    extends State<ChecksheetInventarisReviewPage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();

  bool _showBackToTop = false;
  bool _isLoading = true;
  bool _isApproving = false;
  bool _isRejecting = false;

  ChecksheetReviewModel? _reviewData;

  String _currentSheet = 'Tool Box';

  // ✅ Semua tabs dalam 1 page
  final List<Map<String, dynamic>> _sheets = [
    {'name': 'Tool Box', 'key': 'tool_box', 'icon': Icons.construction},
    {'name': 'Tool Kit', 'key': 'tool_kit', 'icon': Icons.build},
    {'name': 'Mekanik', 'key': 'mekanik', 'icon': Icons.engineering},
    {'name': 'Genset', 'key': 'genset', 'icon': Icons.electrical_services},
    {'name': 'Mekanik 2', 'key': 'mekanik_2', 'icon': Icons.settings},
    {'name': 'Elektrik', 'key': 'elektrik', 'icon': Icons.bolt},
    {'name': 'Gangguan', 'key': 'gangguan', 'icon': Icons.warning},
  ];

  @override
  void initState() {
    super.initState();
    _loadLaporanData();

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLaporanData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await PengawasChecksheetService.getLaporanDetail(
        widget.user.token!,
        widget.laporanId,
      );

      if (mounted) {
        setState(() {
          _reviewData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (AppConfig.isSimulationMode || e.toString().contains('API Error')) {
        print('⚠️ API Error: $e');
        print('📦 Mode Simulasi: Menggunakan mock data...');

        if (mounted) {
          setState(() {
            _reviewData = MockChecksheetData.getMockInventaris(
              widget.laporanId,
            );
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '🔧 Mode Simulasi: Menggunakan data contoh',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.blue.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
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

  String _getInitials() {
    if (widget.user.nama == null || widget.user.nama!.isEmpty) {
      return 'P';
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
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else ...[
            _buildLaporanInfoCard(),
            _buildSheetTabs(),
            _buildSheetTitle(),
            Expanded(
              child: ListView(
                controller: _listScrollController,
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                children: [
                  _buildSheetContent(),
                  const SizedBox(height: 16.0),
                  _buildActionButtons(),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
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
            Navigator.pop(context);
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
    if (_reviewData == null) return const SizedBox.shrink();

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
                      '${_reviewData!.noKa} - ${_reviewData!.namaKa}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Mekanik: ${_reviewData!.namaMekanik}',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(_reviewData!.status),
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
                'Dikirim: ${_formatDateTime(_reviewData!.submittedAt)}',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (_reviewData!.catatanPengawas != null) ...[
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Catatan Penolakan Sebelumnya:',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _reviewData!.catatanPengawas!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.red.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Pending Approval':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        icon = Icons.pending;
        break;
      case 'Approved':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
        break;
      case 'Rejected':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
        break;
      default:
        bgColor = Colors.grey.shade50;
        textColor = Colors.grey.shade700;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.0, color: textColor),
          const SizedBox(width: 4.0),
          Text(
            status,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }

  Widget _buildSheetTabs() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      height: 50.0,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _sheets.length,
        itemBuilder: (context, index) {
          final sheet = _sheets[index];
          final isSelected = _currentSheet == sheet['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentSheet = sheet['name'];
              });
              // Scroll to top saat ganti tab
              if (_listScrollController.hasClients) {
                _listScrollController.jumpTo(0);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF2196F3) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
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
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
            '$_currentSheet Checksheet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            'Mode Review',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Router untuk konten berdasarkan tab yang dipilih
  Widget _buildSheetContent() {
    if (_reviewData == null) return const SizedBox.shrink();

    final sheetKey = _sheets.firstWhere(
      (s) => s['name'] == _currentSheet,
      orElse: () => _sheets[0],
    )['key'];

    // Tool Box & Tool Kit (format lama - List)
    if (sheetKey == 'tool_box' || sheetKey == 'tool_kit') {
      return _buildInventarisSection(sheetKey);
    }

    // Mekanik & Genset (format baru - Map dengan kategori)
    if (sheetKey == 'mekanik' || sheetKey == 'genset') {
      return _buildKategoriSection(sheetKey);
    }

    // Mekanik 2 & Elektrik (list gerbong)
    if (sheetKey == 'mekanik_2' || sheetKey == 'elektrik') {
      return _buildGerbongListSection(sheetKey);
    }

    // Gangguan
    if (sheetKey == 'gangguan') {
      return _buildGangguanSection();
    }

    return _buildEmptyState();
  }

  // ✅ Section untuk Tool Box & Tool Kit
  Widget _buildInventarisSection(String key) {
    final items = _reviewData!.sheets[key] as List<dynamic>?;

    if (items == null || items.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children:
          items.map((item) {
            final itemModel = InventarisReviewItemModel.fromJson(item);
            return _buildInventarisItem(itemModel);
          }).toList(),
    );
  }

  // ✅ Section untuk Mekanik & Genset (dengan kategori)
  Widget _buildKategoriSection(String key) {
    final sheetData = _reviewData!.sheets[key];

    if (sheetData == null) {
      return _buildEmptyState();
    }

    if (sheetData is Map<String, dynamic>) {
      final kategoriList = sheetData['kategori'] as List<dynamic>?;
      if (kategoriList == null || kategoriList.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: kategoriList.map((kategori) {
          final namaKategori = kategori['nama_kategori'] ?? '';
          final items = kategori['items'] as List<dynamic>? ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKategoriHeader(namaKategori),
              ...items.map((item) => _buildKomponenItem(item)).toList(),
            ],
          );
        }).toList(),
      );
    }

    return _buildEmptyState();
  }

  // ✅ Section untuk Mekanik 2 & Elektrik (list gerbong) - UPDATED
  Widget _buildGerbongListSection(String key) {
    final sheetData = _reviewData!.sheets[key];

    if (sheetData == null || sheetData is! Map<String, dynamic>) {
      return _buildEmptyState();
    }

    final gerbongList = sheetData['gerbong_list'] as List<dynamic>?;

    if (gerbongList == null || gerbongList.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header info
        Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.train, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Daftar gerbong yang sudah diperiksa oleh Mekanik',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        // List gerbong
        ...gerbongList.map((gerbong) {
          return _buildGerbongCard(gerbong as Map<String, dynamic>);
        }).toList(),
      ],
    );
  }

  // ✅ Card untuk setiap gerbong
  Widget _buildGerbongCard(Map<String, dynamic> gerbong) {
    final gerbongId = gerbong['gerbong_id'] ?? '';
    final namaGerbong = gerbong['nama_gerbong'] ?? '';
    final status = gerbong['status'] ?? '';
    final jumlahItem = gerbong['jumlah_item'] ?? 0;
    final itemSelesai = gerbong['item_selesai'] ?? 0;
    final catatan = gerbong['catatan'] ?? '';

    // Status color
    Color statusColor;
    IconData statusIcon;

    if (status == 'Selesai Diperbaiki') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'Dalam Perbaikan') {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.warning;
    }

    // Progress percentage
    final progress = jumlahItem > 0 ? (itemSelesai / jumlahItem) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header gerbong
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                // Gerbong icon
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.train,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Gerbong info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gerbongId,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        namaGerbong,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress & detail
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                Row(
                  children: [
                    Text(
                      'Progress Pemeriksaan:',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$itemSelesai/$jumlahItem',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 8,
                  ),
                ),
                // Catatan
                if (catatan.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            catatan,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Section untuk Gangguan
  Widget _buildGangguanSection() {
    final logGangguan = _reviewData!.logGangguan;

    if (logGangguan.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 64, color: Colors.green[400]),
              const SizedBox(height: 16),
              Text(
                'Tidak ada gangguan yang dilaporkan',
                style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: logGangguan.map((gangguan) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gangguan['jenis_gangguan'] ?? 'Gangguan',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                gangguan['deskripsi'] ?? '',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ✅ Header kategori
  Widget _buildKategoriHeader(String kategori) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_open,
            size: 18,
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(width: 8),
          Text(
            kategori,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Item komponen (Mekanik & Genset)
  Widget _buildKomponenItem(Map<String, dynamic> item) {
    final itemPemeriksaan = item['item_pemeriksaan'] ?? '';
    final standar = item['standar'] ?? '';
    final hasilInput = item['hasil_input'] ?? '';
    final keterangan = item['keterangan'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemPemeriksaan,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                bottom: BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Standar:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                Flexible(
                  child: Text(
                    standar,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2196F3),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Colors.green.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hasil: ',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Expanded(
                  child: Text(
                    hasilInput,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (keterangan.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keterangan:',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    keterangan,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInventarisItem(InventarisReviewItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.itemPemeriksaan,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Terisi',
                      style: GoogleFonts.inter(
                        fontSize: 10,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6.0),
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
          if (item.kondisi != null) ...[
            Row(
              children: [
                Text(
                  'Kondisi:',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        item.kondisi!.toUpperCase() == 'BAIK'
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color:
                          item.kondisi!.toUpperCase() == 'BAIK'
                              ? Colors.green
                              : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    item.kondisi!,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color:
                          item.kondisi!.toUpperCase() == 'BAIK'
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
          ],
          if (item.jumlah != null) ...[
            Row(
              children: [
                Text(
                  'Jumlah:',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                Text(
                  item.jumlah!,
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
          ],
          if (item.keterangan != null && item.keterangan!.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: 8.0),
            Text(
              'Keterangan:',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              item.keterangan!,
              style: GoogleFonts.inter(fontSize: 12.0, color: Colors.grey[800]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Data $_currentSheet belum tersedia',
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_reviewData == null || _reviewData!.status != 'Pending Approval') {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isApproving || _isRejecting ? null : _handleApprove,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
            ),
            child:
                _isApproving
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Setujui Laporan',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isApproving || _isRejecting ? null : _handleReject,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child:
                _isRejecting
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        strokeWidth: 2,
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cancel, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Tolak Laporan',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleApprove() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 8,
            backgroundColor: Colors.white,
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.green.shade600,
              ),
            ),
            title: Text(
              'Konfirmasi Persetujuan',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.grey.shade900,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Apakah Anda yakin ingin menyetujui laporan ini?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Setelah disetujui, laporan tidak dapat diubah lagi.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.orange.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Ya, Setujui',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    if (!mounted) return;

    setState(() {
      _isApproving = true;
    });

    try {
      try {
        final result = await PengawasChecksheetService.approveLaporan(
          widget.user.token!,
          widget.laporanId,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result['message'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '✓ Laporan berhasil disetujui (Simulasi)',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );

        if (!mounted) return;

        setState(() {
          _reviewData = ChecksheetReviewModel(
            laporanId: _reviewData!.laporanId,
            noKa: _reviewData!.noKa,
            namaKa: _reviewData!.namaKa,
            namaMekanik: _reviewData!.namaMekanik,
            status: 'Approved',
            submittedAt: _reviewData!.submittedAt,
            sheets: _reviewData!.sheets,
            catatanPengawas: null,
            logGangguan: _reviewData!.logGangguan,
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApproving = false;
        });
      }
    }
  }

  Future<void> _handleReject() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 8,
            backgroundColor: Colors.white,
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cancel_outlined,
                size: 48,
                color: Colors.red.shade600,
              ),
            ),
            title: Text(
              'Tolak Laporan',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.grey.shade900,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Berikan alasan penolakan:',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  maxLength: 200,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        'Contoh: Data Tool Box tidak lengkap, jumlah tang kombinasi kurang dari standar...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pastikan alasan penolakan jelas dan dapat dipahami oleh mekanik.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Alasan penolakan wajib diisi',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.orange.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, controller.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Tolak',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );

    if (result == null) return;

    if (!mounted) return;

    setState(() {
      _isRejecting = true;
    });

    try {
      try {
        final response = await PengawasChecksheetService.rejectLaporan(
          widget.user.token!,
          widget.laporanId,
          result,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    response['message'],
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '✓ Laporan berhasil ditolak (Simulasi)',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );

        if (!mounted) return;

        setState(() {
          _reviewData = ChecksheetReviewModel(
            laporanId: _reviewData!.laporanId,
            noKa: _reviewData!.noKa,
            namaKa: _reviewData!.namaKa,
            namaMekanik: _reviewData!.namaMekanik,
            status: 'Rejected',
            submittedAt: _reviewData!.submittedAt,
            sheets: _reviewData!.sheets,
            catatanPengawas: result,
            logGangguan: _reviewData!.logGangguan,
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRejecting = false;
        });
      }
    }
  }
}

// Model untuk item inventaris review
class InventarisReviewItemModel {
  final String itemPemeriksaan;
  final String standar;
  final String? kondisi;
  final String? jumlah;
  final String? keterangan;

  InventarisReviewItemModel({
    required this.itemPemeriksaan,
    required this.standar,
    this.kondisi,
    this.jumlah,
    this.keterangan,
  });

  factory InventarisReviewItemModel.fromJson(Map<String, dynamic> json) {
    return InventarisReviewItemModel(
      itemPemeriksaan: json['item_pemeriksaan'] ?? '',
      standar: json['standar'] ?? '',
      kondisi: json['kondisi'],
      jumlah: json['jumlah'],
      keterangan: json['keterangan'],
    );
  }
}
