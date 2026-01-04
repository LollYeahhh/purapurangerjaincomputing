import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../models/checksheet_review_model.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';

/// ChecksheetKomponenReviewPage - Halaman review Mekanik & Genset untuk Pengawas
/// Menampilkan data checksheet yang sudah diisi Mekanik (read-only)
/// Pengawas dapat Approve atau Reject laporan
class ChecksheetKomponenReviewPage extends StatefulWidget {
  final User user;
  final int laporanId;
  final String initialSheet; // 'mekanik' atau 'genset'

  const ChecksheetKomponenReviewPage({
    Key? key,
    required this.user,
    required this.laporanId,
    this.initialSheet = 'mekanik',
  }) : super(key: key);

  @override
  State<ChecksheetKomponenReviewPage> createState() =>
      _ChecksheetKomponenReviewPageState();
}

class _ChecksheetKomponenReviewPageState
    extends State<ChecksheetKomponenReviewPage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();

  // State variables
  ChecksheetReviewModel? _reviewData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isApproving = false;
  bool _isRejecting = false;

  // UI State
  String _currentSheet = 'mekanik'; // Default sheet
  bool _showBackToTop = false;
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  double _scrollProgress = 0.0;

  // Sheet approval tracking
  final Map<String, bool> _sheetApprovalStatus = {
    'mekanik': false,
    'genset': false,
  };

  // Sheet tabs
  final List<Map<String, dynamic>> _sheets = [
    {'name': 'mekanik', 'label': 'Mekanik', 'icon': Icons.build},
    {'name': 'genset', 'label': 'Genset', 'icon': Icons.power},
  ];

  @override
  void initState() {
    super.initState();
    _currentSheet = widget.initialSheet;

    _scrollController.addListener(_updateScrollArrows);
    _listScrollController.addListener(_updateBackToTopVisibility);

    _fetchLaporanData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  /// Fetch data laporan dari API
  Future<void> _fetchLaporanData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getLaporanDetail(
        widget.user.token ?? '',
        widget.laporanId,
      );

      if (mounted) {
        setState(() {
          _reviewData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Handle Approve untuk sheet tertentu
  Future<void> _handleApproveSheet() async {
    final confirm = await _showApproveDialog();
    if (confirm != true) return;

    if (!mounted) return;

    setState(() {
      _isApproving = true;
    });

    try {
      // TODO: Implementasi API untuk approve per sheet
      await Future.delayed(const Duration(seconds: 1)); // Simulasi API call

      if (!mounted) return;

      setState(() {
        _sheetApprovalStatus[_currentSheet] = true;
        _isApproving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sheet $_currentSheet berhasil disetujui',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Cek apakah semua sheet sudah di-approve
      if (_sheetApprovalStatus.values.every((approved) => approved)) {
        _showAllApprovedDialog();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isApproving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyetujui sheet: $e',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  /// Handle Reject untuk sheet tertentu
  Future<void> _handleRejectSheet() async {
    final reason = await _showRejectDialog();
    if (reason == null || reason.isEmpty) return;

    if (!mounted) return;

    setState(() {
      _isRejecting = true;
    });

    try {
      // TODO: Implementasi API untuk reject per sheet dengan alasan
      await Future.delayed(const Duration(seconds: 1)); // Simulasi API call

      if (!mounted) return;

      setState(() {
        _isRejecting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sheet $_currentSheet ditolak',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Kembali ke dashboard
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isRejecting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menolak sheet: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  // Scroll helpers
  void _updateScrollArrows() {
    if (!mounted || !_scrollController.hasClients) return;

    setState(() {
      _showLeftArrow = _scrollController.offset > 0;
      _showRightArrow =
          _scrollController.offset < _scrollController.position.maxScrollExtent;
      _scrollProgress =
          _scrollController.position.maxScrollExtent > 0
              ? _scrollController.offset /
                  _scrollController.position.maxScrollExtent
              : 0;
    });
  }

  void _updateBackToTopVisibility() {
    if (!mounted || !_listScrollController.hasClients) return;

    final showButton = _listScrollController.offset > 200;
    if (_showBackToTop != showButton) {
      setState(() {
        _showBackToTop = showButton;
      });
    }
  }

  void _scrollTabsBy(double offset) {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      (_scrollController.offset + offset).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollToTop() {
    if (!_listScrollController.hasClients) return;

    _listScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          Column(
            children: [
              _buildCustomHeader(),
              _buildBackButton(),
              if (_reviewData != null) _buildInfoCard(),
              _buildTabBar(),
              Expanded(
                child:
                    _isLoading
                        ? _buildLoadingState()
                        : _errorMessage != null
                        ? _buildErrorState()
                        : _buildChecksheetContent(),
              ),
            ],
          ),
          if (_showBackToTop) _buildBackToTopButton(),
        ],
      ),
    );
  }

  /// Custom Header dengan Logo KAI dan Avatar
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
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo_putih.png',
                height: 32,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 32,
                    width: 60,
                    color: Colors.white.withOpacity(0.2),
                    child: Center(
                      child: Text(
                        'KAI',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () => _showProfileMenu(context),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    (widget.user.nama ?? 'P')[0].toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C2A6B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol Kembali ke Review Utama
  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text(
            'Kembali ke Review Laporan',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2C2A6B),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }

  /// Info Card Laporan
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C2A6B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          _reviewData!.namaMekanik,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
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

  /// Tab Bar untuk Sheet Selection
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            children:
                _sheets.map((sheet) {
                  final isActive = _currentSheet == sheet['name'];
                  final isApproved = _sheetApprovalStatus[sheet['name']] ?? false;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        setState(() {
                          _currentSheet = sheet['name'];
                        });

                        // Scroll to top when switching tabs
                        if (_listScrollController.hasClients) {
                          _listScrollController.jumpTo(0);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? const Color(0xFF2196F3)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color:
                                isActive
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey.shade300,
                          ),
                          boxShadow:
                              isActive
                                  ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              sheet['icon'],
                              size: 18,
                              color:
                                  isActive
                                      ? Colors.white
                                      : const Color(0xFF2C2A6B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              sheet['label'],
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight:
                                    isActive
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                color:
                                    isActive
                                        ? Colors.white
                                        : const Color(0xFF2C2A6B),
                              ),
                            ),
                            if (isApproved) ..[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: isActive ? Colors.white : Colors.green,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// Checksheet Content
  Widget _buildChecksheetContent() {
    if (_reviewData == null) {
      return const Center(child: Text('Data tidak tersedia'));
    }

    final sheetData = _reviewData!.sheets[_currentSheet];

    if (sheetData == null) {
      return _buildEmptyState();
    }

    // Cek format data: apakah Map (dengan kategori) atau List
    if (sheetData is Map<String, dynamic>) {
      final kategoriList = sheetData['kategori'] as List<dynamic>?;
      if (kategoriList == null || kategoriList.isEmpty) {
        return _buildEmptyState();
      }

      return _buildKategoriContent(kategoriList);
    } else {
      return _buildEmptyState();
    }
  }

  /// Build content dengan kategori
  Widget _buildKategoriContent(List<dynamic> kategoriList) {
    return ListView.builder(
      controller: _listScrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: kategoriList.length + 1, // +1 untuk action buttons
      itemBuilder: (context, index) {
        if (index == kategoriList.length) {
          return _buildActionButtons();
        }

        final kategori = kategoriList[index] as Map<String, dynamic>;
        final namaKategori = kategori['nama_kategori'] ?? '';
        final items = kategori['items'] as List<dynamic>? ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKategoriHeader(namaKategori),
            ...items.map((item) => _buildChecksheetItem(item)).toList(),
          ],
        );
      },
    );
  }

  /// Kategori Header
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

  /// Checksheet Item (Read-only)
  Widget _buildChecksheetItem(Map<String, dynamic> item) {
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
          // Item Pemeriksaan
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

          // Standar
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

          // Hasil Input
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

          // Keterangan (jika ada)
          if (keterangan.isNotEmpty) ..[
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

  /// Action Buttons (Approve & Reject per sheet)
  Widget _buildActionButtons() {
    final isApproved = _sheetApprovalStatus[_currentSheet] ?? false;

    if (isApproved) {
      return Container(
        margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sheet $_currentSheet sudah disetujui',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Row(
        children: [
          // Reject Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isApproving || _isRejecting ? null : _handleRejectSheet,
              icon:
                  _isRejecting
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Icon(Icons.cancel_outlined, size: 20),
              label: Text(
                _isRejecting ? 'Menolak...' : 'Tolak',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Approve Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isApproving || _isRejecting ? null : _handleApproveSheet,
              icon:
                  _isApproving
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                _isApproving ? 'Menyetujui...' : 'Setujui',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada data untuk sheet ini',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C2A6B)),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat data laporan...',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Error State
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchLaporanData,
              icon: const Icon(Icons.refresh, size: 20),
              label: Text(
                'Coba Lagi',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2A6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Back to Top Button
  Widget _buildBackToTopButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton.small(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
      ),
    );
  }

  /// Show Approve Dialog
  Future<bool?> _showApproveDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
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
              'Setujui Sheet $_currentSheet?',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Anda akan menyetujui data checksheet $_currentSheet.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Batal',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Setujui',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Show Reject Dialog
  Future<String?> _showRejectDialog() {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
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
              'Tolak Sheet $_currentSheet?',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Berikan alasan penolakan untuk Mekanik.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Data checksheet tidak lengkap...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text(
                  'Batal',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alasan wajib diisi'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, controller.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Show All Approved Dialog
  void _showAllApprovedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 48,
                color: Colors.green.shade600,
              ),
            ),
            title: Text(
              'Semua Sheet Disetujui!',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Semua checksheet sudah disetujui. Kembali ke dashboard?',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Kembali ke Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Profile Menu
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF2C2A6B),
                  child: Text(
                    (widget.user.nama ?? 'P')[0].toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.user.nama ?? 'Pengawas',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIPP: ${widget.user.nipp}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Keluar',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
