import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../models/user_model.dart';
import '../../models/jadwal_model.dart';
import '../../services/api_service.dart';
import '../auth/login_page.dart';

class MekanikHomePage extends StatefulWidget {
  final User user;

  const MekanikHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<MekanikHomePage> createState() => _MekanikHomePageState();
}

class _MekanikHomePageState extends State<MekanikHomePage> {
  List<JadwalModel> _jadwalList = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
    _loadJadwal();

    print('User logged in: ${widget.user.nama}');
    print('User NIPP: ${widget.user.nipp}');
  }

  //Function untuk initialize locale
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
      // Fallback: set as initialized anyway
      if (mounted) {
        setState(() {
          _isLocaleInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadJadwal() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final jadwalList = await ApiService.getDashboardJadwal(
        widget.user.token ?? '',
      );
      if (mounted) {
        setState(() {
          _jadwalList = jadwalList;
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

  // Update function dengan error handling
  String _getFormattedDate() {
    try {
      final now = DateTime.now();
      // Jika locale belum ready, gunakan format simple
      if (!_isLocaleInitialized) {
        return DateFormat('EEEE, d MMMM yyyy').format(now);
      }
      // Gunakan locale Indonesia
      final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
      return formatter.format(now);
    } catch (e) {
      // Fallback jika ada error
      print('Error formatting date: $e');
      final now = DateTime.now();
      return DateFormat('EEEE, d MMMM yyyy').format(now);
    }
  }

  String _getFirstName() {
    if (widget.user.nama == null || widget.user.nama!.isEmpty) {
      return 'Mekanik';
    }
    return widget.user.nama!.split(' ').first;
  }

  String _getFullName() {
    return widget.user.nama ?? 'Mekanik';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadJadwal,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? _buildErrorWidget()
                : _buildContent(),
      ),
    );
  }

  // ... rest of the code remains the same

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
              onPressed: _loadJadwal,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
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
                    Text(
                      'Selamat Datang, ${_getFirstName()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      _getFormattedDate(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Jadwal Penugasan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 1.0),
              ],
            ),
          ),
        ),

        if (_jadwalList.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyState())
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildJadwalCard(_jadwalList[index]);
              }, childCount: _jadwalList.length),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
      ],
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Mekanik',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
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

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy, size: 64.0, color: Colors.grey[400]),
          const SizedBox(height: 16.0),
          Text(
            'Tidak ada jadwal hari ini',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(JadwalModel jadwal) {
    Color badgeColor;
    String badgeText;
    Color buttonColor;
    String buttonText;

    switch (jadwal.statusLaporan.toLowerCase()) {
      case 'baru':
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'GMR-SMT';
        buttonColor = const Color(0xFF2196F3);
        buttonText = 'Mulai';
        break;
      case 'draft':
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'BD-GMR';
        buttonColor = const Color(0xFFFFC107);
        buttonText = 'Lanjutkan';
        break;
      case 'menunggu':
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'BD-GMR';
        buttonColor = const Color(0xFF2196F3);
        buttonText = 'Menunggu';
        break;
      case 'ditinjau':
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'BD-GMR';
        buttonColor = const Color(0xFFFFC107);
        buttonText = 'Ditinjau';
        break;
      case 'diterima':
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'BD-GMR';
        buttonColor = const Color(0xFF4CAF50);
        buttonText = 'Diterima';
        break;
      case 'ditolak':
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'BD-GMR';
        buttonColor = const Color(0xFFF44336);
        buttonText = 'Ditolak';
        break;
      default:
        badgeColor = const Color(0xFF00BFA6);
        badgeText = 'GMR-SMT';
        buttonColor = Colors.grey;
        buttonText = jadwal.statusLaporan;
    }

    // DITAMBAHKAN: Warna hover yang dapat diubah
    Color hoverColor = Colors.white.withOpacity(0.2); // Ubah warna di sini

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
                  '${jadwal.noKa} - ${jadwal.namaKa}',
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
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.0,
                color: const Color(0xFF2196F3),
              ),
              const SizedBox(width: 6.0),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: Colors.grey[600],
                  ),
                  children: [
                    TextSpan(text: 'Jadwal Berangkat: '),
                    TextSpan(
                      text: jadwal.jamBerangkat,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          Divider(color: Colors.grey.shade300, thickness: 1.0, height: 1.0),
          const SizedBox(height: 16.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Checksheet',
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    jadwal.statusLaporan,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: buttonColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _handleJadwalAction(jadwal);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(115, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                ).copyWith(
                  // Efek hover dengan kontrol warna
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      // UBAH WARNA HOVER
                      // return buttonColor.withOpacity(0.8);
                      return Color.lerp(buttonColor, Colors.white, 0.2)!;
                      // return Color.lerp(buttonColor, Colors.black, 0.2)!;
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return buttonColor.withOpacity(0.7); // Saat ditekan
                    }
                    return buttonColor; // Warna default
                  }),
                  elevation: MaterialStateProperty.resolveWith<double>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return 2.0; // Shadow saat hover
                    }
                    return 0.0;
                  }),
                  //Overlay color untuk ripple effect
                  overlayColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.pressed)) {
                      return hoverColor; // variabel hoverColor
                    }
                    return Colors.transparent;
                  }),
                ),
                child: Text(
                  buttonText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.0,
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

  void _handleJadwalAction(JadwalModel jadwal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka ${jadwal.noKa} - ${jadwal.namaKa}'),
        backgroundColor: const Color(0xFF2C2A6B),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
