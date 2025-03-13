import 'package:library_application/config.dart';

import '/components/bottom_bar_profile_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'pinjam_buku_model.dart';
export 'pinjam_buku_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinjamBukuWidget extends StatefulWidget {
  const PinjamBukuWidget({super.key});

  @override
  State<PinjamBukuWidget> createState() => _PinjamBukuWidgetState();
}

class _PinjamBukuWidgetState extends State<PinjamBukuWidget>
    with TickerProviderStateMixin {
  late PinjamBukuModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Define the lists to store book data by status
  List<dynamic> processingBooks = [];
  List<dynamic> acceptedBooks = [];
  List<dynamic> rejectedBooks = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PinjamBukuModel());

    // Inisialisasi textController dan textFieldFocusNode
    _model.textController = TextEditingController();
    _model.textFieldFocusNode = FocusNode();

    // Inisialisasi tab controller
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() {
        safeSetState(() {});
        // Fetch data when tab changes
        switch (_model.tabBarController!.index) {
          case 0:
            fetchBookData(status: 'REQ'); // Diproses
            break;
          case 1:
            fetchBookData(status: 'ACCEPTED'); // Diterima
            break;
          case 2:
            fetchBookData(status: 'REJECTED'); // Ditolak
            break;
        }
      });

    // Fetch data for the initial tab
    fetchBookData(status: 'REQ'); // Ambil data untuk tab Diproses

    // Listen for search query changes
    _model.textController!.addListener(() {
      setState(() {
        searchQuery = _model.textController!.text;
      });
      filterBooks();
    });
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
    return prefs.getInt('userId');
  }

  // Function to fetch book data from API
  Future<void> fetchBookData({String? status}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId =
          prefs.getInt('userId'); // Ambil ID user dari SharedPreferences

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

      var url = Uri.parse('$apiUrl/api/pinjam-buku');
      if (status != null) {
        url = url.replace(
            queryParameters: {'status': status, 'id_user': userId.toString()});
      } else {
        url = url.replace(queryParameters: {'id_user': userId.toString()});
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Respons API: ${response.body}');
        print('Data dari API: $data');

        if (data['data'] != null) {
          setState(() {
            processingBooks = data['data']
                .where((book) => book['status_peminjaman'] == 'REQ')
                .toList();
            acceptedBooks = data['data']
                .where(
                    (book) => book['status_peminjaman'] == 'IS BEING BORROWED')
                .toList();
            rejectedBooks = data['data']
                .where((book) => book['status_peminjaman'] == 'REJECTED')
                .toList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data buku'),
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

  // Function to filter books based on search query
  void filterBooks() {
    if (searchQuery.isEmpty) {
      fetchBookData(); // Reset to original data
      return;
    }

    setState(() {
      processingBooks = processingBooks
          .where((book) => book['judul_buku']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();

      acceptedBooks = acceptedBooks
          .where((book) => book['judul_buku']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();

      rejectedBooks = rejectedBooks
          .where((book) => book['judul_buku']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  // Function to update book status
  Future<void> updateBookStatus(int id, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('https://your-api-url.com/api/pinjam-buku/$id'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers here if needed
        },
        body: json.encode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh the data
        fetchBookData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status buku berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memperbarui status buku'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Pinjam Buku',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Inter Tight',
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            // Add a refresh button
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.refresh_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () {
                switch (_model.tabBarController!.index) {
                  case 0:
                    fetchBookData(status: 'REQ');
                    break;
                  case 1:
                    fetchBookData(status: 'ACCEPTED');
                    break;
                  case 2:
                    fetchBookData(status: 'REJECTED');
                    break;
                }
              },
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 20.0, 15.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Cari berdasarkan judul ',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
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
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model.textControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: const Alignment(-1.0, 0),
                        child: FlutterFlowButtonTabBar(
                          useToggleButtonStyle: false,
                          isScrollable: true,
                          labelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                  ),
                          unselectedLabelStyle: const TextStyle(),
                          labelColor: Colors.white,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          backgroundColor: const Color(0xFF2679C2),
                          borderColor: const Color(0xFF2679C2),
                          borderWidth: 2.0,
                          borderRadius: 12.0,
                          elevation: 0.0,
                          labelPadding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          buttonMargin: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 16.0, 0.0),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          tabs: const [
                            Tab(
                              text: 'Diproses',
                            ),
                            Tab(
                              text: 'Diterima',
                            ),
                            Tab(
                              text: 'Ditolak',
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}, () async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            // Processing Books Tab (REQ status)
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : processingBooks.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Tidak ada buku yang sedang diproses',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: processingBooks.length,
                                        itemBuilder: (context, index) {
                                          final book = processingBooks[index];
                                          return buildBookCard(book);
                                        },
                                      ),

                            // Accepted Books Tab (ACCEPTED status)
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : acceptedBooks.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Tidak ada buku yang diterima',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: acceptedBooks.length,
                                        itemBuilder: (context, index) {
                                          final book = acceptedBooks[index];
                                          return buildBookCard(book);
                                        },
                                      ),

                            // Rejected Books Tab (REJECTED status)
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : rejectedBooks.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Tidak ada buku yang ditolak',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: rejectedBooks.length,
                                        itemBuilder: (context, index) {
                                          final book = rejectedBooks[index];
                                          return buildBookCard(book);
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBookCard(dynamic peminjaman) {
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
            )
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
                  peminjaman['gambar'] != null &&
                          peminjaman['gambar'].isNotEmpty
                      ? '$apiUrl/${peminjaman['gambar']}'
                      : 'https://via.placeholder.com/70x100?text=No+Image', // Default image URL
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
                      peminjaman['judul_buku'].toString(),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Tgl. Pinjam: ${formatDate(peminjaman['tanggal_pinjam'].toString())}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    Text(
                      'Tgl. Kembali: ${formatDate(peminjaman['tanggal_kembali']?.toString() ?? '')}',
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
