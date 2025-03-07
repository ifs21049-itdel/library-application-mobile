import 'package:flutter/material.dart';
import 'package:library_application/config.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'detail_buku_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_application/components/login_modal.dart' as LoginModal;

export 'detail_buku_model.dart';

class DetailBukuWidget extends StatefulWidget {
  final String bookId;

  const DetailBukuWidget({super.key, required this.bookId});

  @override
  State<DetailBukuWidget> createState() => _DetailBukuWidgetState();
}

class _DetailBukuWidgetState extends State<DetailBukuWidget> {
  late DetailBukuModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? currentUser;
  Map<String, dynamic>? bookData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetailBukuModel());
    fetchBookData();
    loadData();
  }

  Future<void> fetchBookData() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/api/book/${widget.bookId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bookData = data['data'];
          isLoading = false;
        });
      } else {
        print('Failed to load book: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching book: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Map<String, dynamic> userData = {};

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      debugPrint(prefs.getString('user_data'));
      userData = prefs.getString('user_data') == null
          ? {}
          : jsonDecode(prefs.getString('user_data')!);
    });
  }

  String safeToString(dynamic value) {
    if (value == null || value.toString().isEmpty) return '-';
    return value.toString();
  }

  Future<void> _pinjamBuku(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString == null) {
      LoginModal.showLoginModal(context);
      return;
    }

    final userData = jsonDecode(userDataString);
    final userId = userData['id'];

    // Get the book image path and title
    final String? bookImage = bookData?['gambar'];
    final String? bookTitle = bookData?['judul'];

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/pinjam-buku'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_buku': int.parse(widget.bookId),
          'id_user': userId,
          'tanggal_pinjam': DateTime.now().toIso8601String(),
          'status': 'REQ',
          'gambar': bookImage,
          'judul_buku': bookTitle,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permintaan peminjaman berhasil dikirim!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Terjadi kesalahan saat mengirim permintaan peminjaman.')),
        );
      }
    } catch (e) {
      print('Error saat peminjaman: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan. Mohon coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (bookData == null) {
      return Scaffold(
        body: Center(child: Text('Data buku tidak ditemukan')),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).info,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            actions: const [],
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.network(
                  bookData?['gambar'] != null && bookData?['gambar'] != 'null'
                      ? '$apiUrl/${bookData!['gambar']}'
                      : 'https://via.placeholder.com/100x100?text=No+Image',
                  // Default image URL
                  width: 100.0,
                  // Tambahkan ukuran lebar
                  height: 100.0,
                  // Tambahkan ukuran tinggi
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.0, 1.0),
                  errorBuilder: (context, error, stackTrace) => Container(
                    width:
                        100.0, // Pastikan ukuran container sesuai dengan gambar
                    height:
                        100.0, // Pastikan ukuran container sesuai dengan gambar
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.book,
                      size: 50.0,
                      color: Colors.grey,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width:
                          100.0, // Pastikan ukuran container sesuai dengan gambar
                      height:
                          100.0, // Pastikan ukuran container sesuai dengan gambar
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
            ),
            centerTitle: false,
            elevation: 2.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, -1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 10.0, 20.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                safeToString(bookData?['judul']),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 25.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      // Repeat for other fields
                      buildDetailRow(
                          'Penulis', safeToString(bookData?['penulis'])),
                      buildDetailRow(
                          'Penerbit', safeToString(bookData?['penerbit'])),
                      buildDetailRow('Tahun Terbit',
                          safeToString(bookData?['tahun_terbit'])),
                      buildDetailRow('ISBN', safeToString(bookData?['isbn'])),
                      buildDetailRow('Jumlah Halaman',
                          safeToString(bookData?['jumlah_halaman'])),
                      buildDetailRow(
                          'Bahasa', safeToString(bookData?['bahasa'])),
                      buildDetailRow('Edisi', safeToString(bookData?['edisi'])),
                      buildDetailRow('Banyak Buku',
                          safeToString(bookData?['banyak_buku'])),
                      buildDetailRow(
                          'Status',
                          (bookData?['status'] == 1)
                              ? 'Tersedia'
                              : 'Tidak Tersedia'),
                      buildDetailRow(
                          'Abstract', safeToString(bookData?['abstrak'])),
                      buildDetailRow(
                          'Lokasi', safeToString(bookData?['lokasi'])),
                      Divider(
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              print('Simpan ke Favorit');
                            },
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5)))),
                            child: Text('Simpan ke Favorit'),
                          ),
                          FilledButton(
                            onPressed: () async {
                              final prefs =
                              await SharedPreferences.getInstance();
                              final userDataString =
                              prefs.getString('user_data');

                              if (userDataString == null) {
                                // Jika pengguna belum login, tampilkan modal login
                                LoginModal.showLoginModal(context);
                                return; // Batalkan peminjaman jika pengguna belum login
                              }

                              // Jika pengguna sudah login, tampilkan pesan konfirmasi
                              final bool? shouldProceed =
                              await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                    const Text('Konfirmasi Peminjaman'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin meminjam buku ini?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // Menutup dialog dan mengembalikan false
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              true); // Menutup dialog dan mengembalikan true
                                        },
                                        child: const Text('Ya'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // Jika pengguna mengonfirmasi, lanjutkan dengan peminjaman buku
                              if (shouldProceed == true) {
                                await _pinjamBuku(context);
                              }
                            },
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5)))),
                            child: Text('Pinjam Buku'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                value,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Divider(
              thickness: 2.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ],
        ),
      ),
    );
  }
}
