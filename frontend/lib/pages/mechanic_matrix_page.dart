import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/component_item.dart';
import '../services/dummy_api_service.dart';
import 'error_page.dart';

/// MechanicMatrixPage - Halaman Form Matriks Mekanik 2 (dengan pilihan gerbong & fase)
class MechanicMatrixPage extends StatefulWidget {
  const MechanicMatrixPage({Key? key}) : super(key: key);

  @override
  State<MechanicMatrixPage> createState() => _MechanicMatrixPageState();
}

class _MechanicMatrixPageState extends State<MechanicMatrixPage> {
  final List<int> _carOptions = List.generate(
    10,
    (index) => index + 1,
  ); // Gerbong 1-10
  final List<String> _phaseOptions = ['Fase 1', 'Fase 2']; // Daftar fase

  int? _selectedCar;
  String? _selectedPhase;
  Future<List<ComponentItem>>? _futureMatrix;
  List<ComponentItem> _matrixItems = [];

  void _handleSubmit() {
    // Validasi semua status sudah dipilih
    for (var item in _matrixItems) {
      if (item.status == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ErrorPage()),
        );
        return;
      }
    }
    // Submit sukses
    final gerbong = _selectedCar;
    final fase = _selectedPhase;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Sukses'),
            content: Text(
              'Form Mekanik - Gerbong $gerbong ($fase) berhasil disimpan.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Mekanik - Matriks',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: const Color(0xFF2C2A6B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown pemilihan Gerbong
            Text(
              'Gerbong',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<int>(
              isExpanded: true,
              value: _selectedCar,
              decoration: InputDecoration(
                hintText: 'Pilih gerbong',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Color(0xFF2C2A6B), width: 2.0),
                ),
              ),
              items:
                  _carOptions
                      .map(
                        (car) => DropdownMenuItem(
                          value: car,
                          child: Text('Gerbong $car'),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCar = value;
                  _matrixItems = [];
                  if (_selectedCar != null && _selectedPhase != null) {
                    // Fetch data matriks ketika kedua pilihan sudah dipilih
                    _futureMatrix = DummyApiService.fetchMechanicMatrixItems(
                      _selectedCar!,
                      _selectedPhase!,
                    );
                  } else {
                    _futureMatrix = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown pemilihan Fase
            Text(
              'Fase',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedPhase,
              decoration: InputDecoration(
                hintText: 'Pilih fase',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Color(0xFF2C2A6B), width: 2.0),
                ),
              ),
              items:
                  _phaseOptions
                      .map(
                        (phase) =>
                            DropdownMenuItem(value: phase, child: Text(phase)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPhase = value;
                  _matrixItems = [];
                  if (_selectedCar != null && _selectedPhase != null) {
                    _futureMatrix = DummyApiService.fetchMechanicMatrixItems(
                      _selectedCar!,
                      _selectedPhase!,
                    );
                  } else {
                    _futureMatrix = null;
                  }
                });
              },
            ),
            const SizedBox(height: 24.0),
            // Jika belum pilih keduanya, tampilkan pesan
            _futureMatrix == null
                ? Expanded(
                  child: Center(
                    child: Text(
                      'Silakan pilih gerbong dan fase',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
                : Expanded(
                  child: FutureBuilder<List<ComponentItem>>(
                    future: _futureMatrix,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = snapshot.data!;
                      if (_matrixItems.isEmpty) {
                        _matrixItems = items;
                      }
                      return ListView.builder(
                        itemCount: _matrixItems.length,
                        itemBuilder: (context, index) {
                          final item = _matrixItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                SizedBox(
                                  width: 120.0,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: item.status,
                                    decoration: InputDecoration(
                                      hintText: 'Pilih',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 8.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Color(0xFF2C2A6B),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Baik',
                                        child: Text('Baik'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Tidak Baik',
                                        child: Text('Tidak Baik'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _matrixItems[index].status = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            // Tombol simpan (muncul hanya jika data sudah di-load)
            if (_futureMatrix != null) ...[
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color(0xFF2C2A6B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: _handleSubmit,
                  child: Text(
                    'SIMPAN',
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
