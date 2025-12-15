import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../models/jadwal_model.dart';
import '../../models/checksheet_gerbong_fase_model.dart';
import '../../models/checksheet_kategori_model.dart';
import '../../models/checksheet_komponen_model.dart';
import 'checksheet_gerbong_fase_page.dart';
import 'checksheet_inventaris_page.dart';
import 'checksheet_komponen_page.dart';
import 'gangguan_form_page.dart';

class ChecksheetMekanik2ElektrikPage extends StatefulWidget {
  final User user;
  final JadwalModel jadwal;
  final int laporanId;
  final String sheetType; // 'Mekanik 2' atau 'Elektrik'
  final ChecksheetGerbongFaseModel gerbongFaseData;

  const ChecksheetMekanik2ElektrikPage({
    Key? key,
    required this.user,
    required this.jadwal,
    required this.laporanId,
    required this.sheetType,
    required this.gerbongFaseData,
  }) : super(key: key);

  @override
  State<ChecksheetMekanik2ElektrikPage> createState() =>
      _ChecksheetMekanik2ElektrikPageState();
}

class _ChecksheetMekanik2ElektrikPageState
    extends State<ChecksheetMekanik2ElektrikPage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();

  bool _showBackToTop = false;
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  double _scrollProgress = 0.0;

  bool _isLoading = false;
  List<ChecksheetKategoriModel> _kategoriList = [];
  String _catatanPenting = '';

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
    _initializeChecksheetData();

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollArrows());
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

  void _scrollToTop() {
    _listScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool _isAllFilled() {
    for (var kategori in _kategoriList) {
      for (var item in kategori.items) {
        if (item.hasilInput.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _handleNavigation(String sheetName) {
    if (!_isAllFilled()) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Peringatan',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              content: Text(
                'Harap selesaikan semua pemeriksaan sebelum berpindah halaman.',
                style: GoogleFonts.inter(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF2196F3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
      );
      return;
    }

    if (sheetName == 'Tool Box' || sheetName == 'Tool Kit') {
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
    } else if (sheetName == 'Mekanik' || sheetName == 'Genset') {
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
    } else if (sheetName == 'Mekanik 2' || sheetName == 'Elektrik') {
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
  }

  void _initializeChecksheetData() {
    if (_listScrollController.hasClients) {
      _listScrollController.jumpTo(0);
    }

    if (widget.sheetType == 'Mekanik 2') {
      _kategoriList = [
        // ========== BAGIAN DALAM ==========
        ChecksheetKategoriModel(
          namaKategori: 'BAGIAN DALAM',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Pintu-Pintu',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Engsel',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Grendel / Slot Pengunci',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Jendela dan Kaca',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Rel Gorden',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'f. Kursi dan Sandaran',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Tangan-Tangan Tempat Duduk',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'h. Meja-Meja Kereta',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'i. Rak Barang',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'j. Nomor Tempat Duduk',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'k. Gantungan Baju',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'l. Pemecah Kaca',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'm. Lantai Ruang Penumpang',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'n. Over Loop Plat',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'o. Closet dan Pegangan',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'p. Westafel',
              standar: 'Ada',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'q. Kran Air',
              standar: 'Berfungsi',
            ),
          ],
        ),

        // ========== BAGIAN LUAR ==========
        ChecksheetKategoriModel(
          namaKategori: 'BAGIAN LUAR',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Closet dan Pegangan',
              standar: 'Normal',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Rantai Pengaman',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Tuas Distributor',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Slang Air Brake & Stop Kran',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Bearing Roda & Axlebox',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Spiral Ayun',
              standar: 'Tidak Putus',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'h. Spiral Dukung',
              standar: 'Tidak Putus',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'i. Shock Absorber',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'j. Gantungan Pengaman',
              standar: 'Lengkap',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'k. Rubber Bellow',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'l. Uji Coba Rem Statis',
              standar: '5 Kg/cm²',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'm. Semboyan 21 Siang',
              standar: 'Lengkap',
            ),
          ],
        ),
      ];
    } else if (widget.sheetType == 'Elektrik') {
      _kategoriList = [
        ChecksheetKategoriModel(
          namaKategori: 'BAGIAN DALAM',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Panel Kereta',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Kontaktor Panel Kereta',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(itemPemeriksaan: 'c. NFB', standar: 'Baik'),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Kipas',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. Blower/ Exhaust',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'f. Ac Package / Split',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Suhu Ruangan',
              standar: '20-26 °C',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'h. Pintu Otomatis',
              standar: 'Menyala',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'i. Lampu Ruang Penumpang',
              standar: 'Menyala',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'j. Lampu Ruang Bordes',
              standar: 'Menyala',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'k. Lampu Ruang Toilet',
              standar: 'Menyala',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'l. Lampu Baca',
              standar: 'Menyala',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'm. Lampu Informasi',
              standar: 'Menyala',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'n. Saklar/ Kontaktor Penumpang',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'o. Televisi',
              standar: 'Berfungsi',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'p. Load Speaker',
              standar: 'Berfungsi',
            ),
          ],
        ),
        ChecksheetKategoriModel(
          namaKategori: 'BAGIAN LUAR',
          items: [
            ChecksheetKomponenModel(
              itemPemeriksaan: 'a. Junction Box / Coupler',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'b. Kabel Coupler',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'c. Baud Pengikat',
              standar: 'Kencang',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'd. Isolator',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'e. NFB pada Junction Box',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'itemPemeriksaan',
              standar: 'Baik',
            ),
            ChecksheetKomponenModel(
              itemPemeriksaan: 'g. Semboyan 21 Malam',
              standar: 'Menyala',
            ),
          ],
        ),
      ];
    } else {
      _kategoriList = [];
    }
  }

  Widget _buildKategoriSection(ChecksheetKategoriModel kategori) {
    // Untuk semua kategori, render normal (HAPUS logika isCatatanPenting)
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
        ...kategori.items.map((item) {
          return _buildKomponenItem(item);
        }).toList(),
      ],
    );
  }

  Widget _buildCatatanPentingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Catatan Penting
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
            'CATATAN PENTING',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2196F3),
            ),
          ),
        ),

        // TextField untuk catatan penting
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: TextField(
            controller: TextEditingController(text: _catatanPenting)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: _catatanPenting.length),
              ),
            decoration: InputDecoration(
              hintText: 'Tulis catatan penting di sini...',
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
                _catatanPenting = value;
              });
            },
          ),
        ),
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
            '${widget.sheetType} Checksheet',
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

  Widget _buildKomponenItem(ChecksheetKomponenModel item) {
    final standarLower = item.standar.toLowerCase();

    // Deteksi input ANGKA + SATUAN
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

    // Default: Button Choice
    return _buildButtonChoiceItem(item);
  }

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

  Widget _buildButtonChoiceItem(ChecksheetKomponenModel item) {
    final selectedChoice = item.hasilInput.toUpperCase();

    // ✅ Deteksi label button dari standar
    List<String> buttonChoices = _getButtonChoices(item.standar);

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
            ),
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
              border: Border(
                bottom: BorderSide(color: const Color(0xFF2196F3), width: 2.0),
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

          // ✅ Render button dinamis berdasarkan pilihan
          Row(
            children:
                buttonChoices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final choice = entry.value;
                  final isSelected = selectedChoice == choice.toUpperCase();

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < buttonChoices.length - 1 ? 12.0 : 0.0,
                      ),
                      child: _buildKondisiButton(
                        label: choice,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            item.hasilInput = choice.toUpperCase();
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 12.0),
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

  // ✅ Helper method untuk deteksi pilihan button
  List<String> _getButtonChoices(String standar) {
    final standarLower = standar.toLowerCase();

    if (standarLower.contains('berfungsi')) {
      return ['Berfungsi', 'Tidak Berfungsi'];
    } else if (standarLower.contains('normal')) {
      return ['Normal', 'Rusak'];
    } else if (standarLower.contains('baik')) {
      return ['Baik', 'Rusak'];
    } else if (standarLower.contains('lengkap')) {
      return ['Lengkap', 'Tidak Lengkap'];
    } else if (standarLower.contains('ada')) {
      return ['Ada', 'Tidak Ada'];
    } else if (standarLower.contains('putus')) {
      return ['Tidak Putus', 'Putus'];
    } else if (standarLower.contains('menyala')) {
      return ['Menyala', 'Tidak Menyala'];
    } else {
      // Default
      return ['Baik', 'Rusak'];
    }
  }

  Widget _buildKondisiButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
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
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    final allCompleted = _isAllFilled();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: allCompleted && !_isLoading ? _handleSimpan : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
        ),
        child:
            _isLoading
                ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                )
                : Text(
                  'Simpan ${widget.sheetType} Checksheet',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  void _handleSimpan() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                'Data ${widget.sheetType} berhasil disimpan!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pop(context);
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
                  final isSelected = sheet['name'] == widget.sheetType;

                  return GestureDetector(
                    onTap: () {
                      final sheetName = sheet['name'] as String;
                      _handleNavigation(sheetName);
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

  Widget _buildGerbongInfo() {
    final fase =
        widget.gerbongFaseData.faseBerangkat.isNotEmpty
            ? 'Berangkat (B)'
            : 'Kembali (K)';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.train, size: 20.0, color: const Color(0xFF2196F3)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gerbong: ${widget.gerbongFaseData.nomorGerbong}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                Text(
                  'Fase: $fase',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          _buildGerbongInfo(),
          _buildSheetTitle(),
          Expanded(
            child: ListView(
              controller: _listScrollController,
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              children: [
                // Render semua kategori
                ..._kategoriList.map((kategori) {
                  return _buildKategoriSection(kategori);
                }).toList(),

                // ✅ Catatan Penting (di luar kategori)
                _buildCatatanPentingSection(),

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
}
