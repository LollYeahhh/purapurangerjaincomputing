import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_model.dart';
import '../../models/laporan_model.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';
import 'checksheet_inventaris_review_page.dart';

class PengawasHomePage extends StatefulWidget {
  final User user;

  const PengawasHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<PengawasHomePage> createState() => _PengawasHomePageState();
}

class _PengawasHomePageState extends State<PengawasHomePage>
    with SingleTickerProviderStateMixin {
  List<LaporanPendingModel> _pendingList = [];
  List<LaporanApprovedModel> _approvedList = [];
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeLocale();
    _loadDashboard();

    print('Pengawas logged in: ${widget.user.nama}');
    print('Pengawas NIPP: ${widget.user.nipp}');
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      if (mounted) {
        setState(() {
          _isLocaleInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing locale: $e');
      if (mounted) {
        setState(() {
          _isLocaleInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final data = await ApiService.getDashboardPengawas(
        widget.user.token ?? '',
      );
      if (mounted) {
        setState(() {
          _pendingList = data['pending_approval'];
          _approvedList = data['riwayat_approved'];
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

  String _getFormattedDate() {
    try {
      final now = DateTime.now();
      if (!_isLocaleInitialized) {
        return DateFormat('EEEE, d MMMM yyyy').format(now);
      }
      final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
      return formatter.format(now);
    } catch (e) {
      print('Error formatting date: $e');
      final now = DateTime.now();
      return DateFormat('EEEE, d MMMM yyyy').format(now);
    }
  }

  String _getFirstName() {
    if (widget.user.nama == null || widget.user.nama!.isEmpty) {
      return 'Pengawas';
    }
    return widget.user.nama!.split(' ').first;
  }

  String _getFullName() {
    return widget.user.nama ?? 'Pengawas';
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
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? _buildErrorWidget()
                : _buildContent(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.0, color: Colors.red[300]),
            const SizedBox(height: 16.0),
            Text(
              'Gagal memuat data',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loadDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2A6B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: Container(
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
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar with Logo and Profile
                    Row(
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
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            _showUserInfo(context);
                          },
                          child: CircleAvatar(
                            radius: 24.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 22.0,
                              backgroundImage:
                                  widget.user.photoUrl != null
                                      ? NetworkImage(widget.user.photoUrl!)
                                      : null,
                              backgroundColor: const Color(
                                0xFF2C2A6B,
                              ).withOpacity(0.1),
                              child:
                                  widget.user.photoUrl == null
                                      ? Text(
                                        _getInitials(),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2C2A6B),
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    // Greeting
                    Text(
                      'Selamat Datang, ${_getFirstName()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    // Date
                    Text(
                      _getFormattedDate(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Tab Section
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF2196F3),
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: const Color(0xFF2196F3),
                    indicatorWeight: 3.0,
                    labelStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                    unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                    tabs: [
                      Tab(
                        text: 'Menunggu Persetujuan (${_pendingList.length})',
                      ),
                      Tab(text: 'Riwayat'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content Section
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [_buildPendingTab(), _buildRiwayatTab()],
          ),
        ),
      ],
    );
  }

  void _showUserInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundColor: const Color(0xFF2C2A6B).withOpacity(0.1),
                child: Text(
                  _getInitials(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2A6B),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                _getFullName(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'NIPP: ${widget.user.nipp}',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Pengawas',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleLogout(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingTab() {
    if (_pendingList.isEmpty) {
      return _buildEmptyState('Tidak ada laporan yang perlu di-review');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: _pendingList.length,
      itemBuilder: (context, index) {
        return _buildPendingCard(_pendingList[index]);
      },
    );
  }

  Widget _buildRiwayatTab() {
    if (_approvedList.isEmpty) {
      return _buildEmptyState('Belum ada riwayat laporan yang disetujui');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: _approvedList.length,
      itemBuilder: (context, index) {
        return _buildApprovedCard(_approvedList[index]);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80.0, color: Colors.grey[300]),
            const SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingCard(LaporanPendingModel laporan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${laporan.noKa} - ${laporan.namaKa}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'GMR-SMT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          Row(
            children: [
              Text(
                'Mekanik: ',
                style: GoogleFonts.inter(
                  fontSize: 11.0,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                laporan.namaMekanik,
                style: GoogleFonts.inter(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // DIPINDAHKAN: Garis pemisah ke atas
          Divider(color: Colors.grey.shade300, thickness: 1.0, height: 1.0),
          const SizedBox(height: 16.0),

          // DIUBAH: Row untuk menyejajarkan waktu dengan tombol
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Informasi waktu
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.0,
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            color: Colors.grey[600],
                          ),
                          children: [
                            TextSpan(text: 'Diajukan: '),
                            TextSpan(
                              text: DateFormat(
                                'd MMM yyyy, HH.mm',
                                'id_ID',
                              ).format(laporan.submittedAt),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // Tombol Review
              ElevatedButton(
                onPressed: () {
                  // ✅ NAVIGASI KE HALAMAN REVIEW
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChecksheetInventarisReviewPage(
                            user: widget.user,
                            laporanId: laporan.laporanId,
                          ),
                    ),
                  ).then((_) {
                    // Refresh data setelah kembali dari review page
                    _loadDashboard();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return Color.lerp(
                        const Color(0xFF2196F3),
                        Colors.white,
                        0.2,
                      )!;
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return const Color(0xFF2196F3).withOpacity(0.7);
                    }
                    return const Color(0xFF2196F3);
                  }),
                  elevation: MaterialStateProperty.resolveWith<double>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return 2.0;
                    }
                    return 0.0;
                  }),
                ),
                child: Text(
                  'Review',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedCard(LaporanApprovedModel laporan) {
    // ✅ Tentukan warna dan text berdasarkan status
    final bool isRejected = laporan.status == 'rejected';
    final Color statusColor =
        isRejected ? const Color(0xFFF44336) : const Color(0xFF4CAF50);
    final String statusText = isRejected ? 'Ditolak' : 'Disetujui';
    final IconData statusIcon = isRejected ? Icons.cancel : Icons.check_circle;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isRejected ? Colors.red.shade100 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${laporan.noKa} - ${laporan.namaKa}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFA6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'GMR-SMT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          Row(
            children: [
              Text(
                'Mekanik: ',
                style: GoogleFonts.inter(
                  fontSize: 11.0,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                laporan.namaMekanik,
                style: GoogleFonts.inter(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          Divider(color: Colors.grey.shade300, thickness: 1.0, height: 1.0),
          const SizedBox(height: 16.0),

          // ✅ Status Badge
          Row(
            children: [
              Icon(statusIcon, size: 16.0, color: statusColor),
              const SizedBox(width: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Informasi waktu
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.0,
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            color: Colors.grey[600],
                          ),
                          children: [
                            TextSpan(
                              text: isRejected ? 'Ditolak: ' : 'Disetujui: ',
                            ),
                            TextSpan(
                              text: DateFormat(
                                'd MMM yyyy, HH.mm',
                                'id_ID',
                              ).format(laporan.approvedAt),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // Tombol Detail & PDF
              ElevatedButton(
                onPressed: () {
                  if (isRejected) {
                    // ✅ Jika ditolak, buka halaman review untuk lihat detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChecksheetInventarisReviewPage(
                              user: widget.user,
                              laporanId: laporan.laporanId,
                            ),
                      ),
                    );
                  } else {
                    // ✅ Jika disetujui, download PDF
                    _handleDownloadPdf(laporan.laporanId, laporan.pdfUrl);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return Color.lerp(statusColor, Colors.white, 0.2)!;
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return statusColor.withOpacity(0.7);
                    }
                    return statusColor;
                  }),
                  elevation: MaterialStateProperty.resolveWith<double>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return 2.0;
                    }
                    return 0.0;
                  }),
                ),
                child: Text(
                  isRejected ? 'Lihat Detail' : 'Detail & PDF',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownloadPdf(int laporanId, String? pdfUrl) async {
    if (pdfUrl == null || pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF tidak tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // ✅ Gunakan url_launcher untuk membuka PDF di browser
      final Uri url = Uri.parse(pdfUrl);

      // Import package url_launcher
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka URL: $pdfUrl';
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    try {
      if (_isLocaleInitialized) {
        return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dateTime);
      }
      return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
    }
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
