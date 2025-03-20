import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/config.dart';
import 'package:library_application/pages/detail_pengumuman/detail_pengumuman_widget.dart';

import '/components/bottom_bar_pengumuman_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_pengumuman_model.dart';

export 'home_pengumuman_model.dart';

class HomePengumumanWidget extends StatefulWidget {
  const HomePengumumanWidget({super.key});

  @override
  State<HomePengumumanWidget> createState() => _HomePengumumanWidgetState();
}

class _HomePengumumanWidgetState extends State<HomePengumumanWidget> {
  late HomePengumumanModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> pengumuman = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model = createModel(context, () => HomePengumumanModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    fetchPengumuman();
  }

  Future<void> fetchPengumuman() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/pengumuman'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> pengumumanList = data['data'];

        // Urutkan pengumuman berdasarkan created_at (dari yang terbaru ke terlama)
        pengumumanList.sort((a, b) {
          final dateA = DateTime.parse(a['created_at']);
          final dateB = DateTime.parse(b['created_at']);
          return dateB.compareTo(dateA); // Descending order
        });

        setState(() {
          pengumuman = pengumumanList;
          isLoading = false;
        });
      } else {
        print('Failed to load pengumuman: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching pengumuman: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPengumuman(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<dynamic> getFilteredPengumuman() {
    if (searchQuery.isEmpty) {
      return pengumuman; // Jika tidak ada kata kunci, kembalikan semua data
    }

    return pengumuman.where((item) {
      final judul = item['judul']?.toString().toLowerCase() ?? '';
      return judul.contains(searchQuery.toLowerCase());
    }).toList();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy, HH:mm').format(date);
    } catch (e) {
      return '-';
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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Judul Halaman
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 25.0, 0.0, 0.0),
                    child: Text(
                      'Pengumuman Perpustakaan',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 20.0, 20.0, 20.0),
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
                        hintText: 'Cari berdasarkan judul',
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        prefixIcon: const Icon(Icons.search_sharp),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                      onChanged: (value) {
                        filterPengumuman(
                            value); // Panggil fungsi pencarian saat teks berubah
                      },
                    ),
                  ),
                ),

                // Daftar Pengumuman
                Flexible(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : getFilteredPengumuman().isEmpty
                          ? Center(child: Text('Tidak ada pengumuman.'))
                          : ListView.builder(
                              itemCount: getFilteredPengumuman().length,
                              itemBuilder: (context, index) {
                                final item = getFilteredPengumuman()[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPengumumanWidget(
                                                id: item['id'].toString()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 0.0, 20.0, 10.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20.0, 10.0, 20.0, 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '[${item['kategori']}] ',
                                                    style: const TextStyle(
                                                      color: Color(0xFFFF0000),
                                                      // 👈 Warna merah untuk kategori
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: item['judul'],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                          color: Colors
                                                              .black, // 👈 Warna default untuk judul
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_outlined,
                                                  size: 12,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  _formatDate(
                                                      item['created_at']),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                            ),
                ),

                // Bottom Bar
                Align(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  child: wrapWithModel(
                    model: _model.bottomBarPengumumanModel,
                    updateCallback: () => safeSetState(() {}),
                    child: const BottomBarPengumumanWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
