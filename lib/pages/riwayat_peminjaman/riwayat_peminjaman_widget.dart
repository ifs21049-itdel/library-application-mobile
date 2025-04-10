import 'package:library_application/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/bottom_bar_profile_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'riwayat_peminjaman_model.dart';
export 'riwayat_peminjaman_model.dart';

class RiwayatPeminjamanWidget extends StatefulWidget {
  const RiwayatPeminjamanWidget({Key? key}) : super(key: key);

  @override
  State<RiwayatPeminjamanWidget> createState() =>
      _RiwayatPeminjamanWidgetState();
}

class _RiwayatPeminjamanWidgetState extends State<RiwayatPeminjamanWidget> {
  late RiwayatPeminjamanModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> riwayatPeminjaman = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RiwayatPeminjamanModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    fetchRiwayatPeminjaman();
  }

  // Function to format date
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return '-';
    }
  }

  Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    print('User ID retrieved: $userId'); // Log ID yang diambil
    return userId;
  }

  Future<void> fetchRiwayatPeminjaman() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = await getUserId(); // Ambil ID user yang sedang login

      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID tidak ditemukan. Silakan login ulang.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final response = await http.get(
        Uri.parse(
            '$apiUrl/api/pinjam-buku?status=DONE&id_user=$userId'), // Kirim id_user sebagai parameter
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> filteredData =
            data['data'] != null ? List<dynamic>.from(data['data']) : [];

        // Filter data untuk memastikan hanya yang memiliki tanggal_kembali
        setState(() {
          riwayatPeminjaman = filteredData
              .where((riwayat) => riwayat['tanggal_kembali'] != null)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data riwayat peminjaman'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void filterRiwayatPeminjaman(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<dynamic> getFilteredRiwayatPeminjaman() {
    if (searchQuery.isEmpty) {
      return riwayatPeminjaman; // Jika tidak ada kata kunci, kembalikan semua data
    }

    return riwayatPeminjaman.where((riwayat) {
      final judulBuku = riwayat['judul_buku']?.toString().toLowerCase() ?? '';
      return judulBuku.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan tinggi bottom bar untuk padding
    final bottomBarHeight = MediaQuery.of(context).padding.bottom +
        70.0; // Perkiraan tinggi bottom bar

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed('ProfilePage');
            },
          ),
          title: Text(
            'Riwayat Peminjaman',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Inter Tight',
                  letterSpacing: 0.0,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Search field
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      15.0, 20.0, 15.0, 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                        hintText: 'Cari berdasarkan judul ',
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF222222),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                      onChanged: (value) {
                        filterRiwayatPeminjaman(
                            value); // Panggil fungsi pencarian saat teks berubah
                      },
                    ),
                  ),
                ),

                // List view with bottom padding
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : getFilteredRiwayatPeminjaman().isEmpty
                          ? const Center(
                              child:
                                  Text('Tidak ada riwayat peminjaman selesai'),
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: bottomBarHeight),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    getFilteredRiwayatPeminjaman().length,
                                itemBuilder: (context, index) {
                                  final riwayat =
                                      getFilteredRiwayatPeminjaman()[index];
                                  return buildRiwayatCard(riwayat);
                                },
                              ),
                            ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: wrapWithModel(
                model: _model.bottomBarProfileModel,
                updateCallback: () => safeSetState(() {}),
                child: const BottomBarProfileWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRiwayatCard(dynamic riwayat) {
    if (riwayat == null || riwayat['tanggal_kembali'] == null) {
      return Container(); // Skip jika data tidak valid
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 2.0),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  riwayat['gambar'] != null && riwayat['gambar'].isNotEmpty
                      ? '$apiUrl/${riwayat['gambar']}'
                      : 'https://via.placeholder.com/70x100?text=No+Image',
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70.0,
                    height: 70.0,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.book,
                      size: 30.0,
                      color: Colors.grey,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 70.0,
                      height: 70.0,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      riwayat['judul_buku'] ?? 'Judul Tidak Tersedia',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Tgl. Pinjam: ${formatDate(riwayat['tanggal_pinjam']?.toString() ?? '')}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    Text(
                      'Tgl. Kembali: ${formatDate(riwayat['tanggal_kembali']?.toString() ?? '')}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
