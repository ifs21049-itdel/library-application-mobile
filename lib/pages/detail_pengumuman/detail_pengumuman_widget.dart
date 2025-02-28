import '/components/bottom_bar_pengumuman_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'detail_pengumuman_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart'; // Pastikan config.dart berisi apiUrl

export 'detail_pengumuman_model.dart';

class DetailPengumumanWidget extends StatefulWidget {
  final String id; // Tambahkan parameter id
  const DetailPengumumanWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPengumumanWidget> createState() => _DetailPengumumanWidgetState();
}

class _DetailPengumumanWidgetState extends State<DetailPengumumanWidget> {
  late DetailPengumumanModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic pengumuman;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetailPengumumanModel());
    fetchPengumuman();
  }

  Future<void> fetchPengumuman() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/api/pengumuman/${widget.id}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          setState(() {
            pengumuman = data['data'];
            isLoading = false;
          });
        } else {
          print('Invalid data format from API: ${response.body}');
          setState(() {
            isLoading = false;
          });
        }
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
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Flexible(
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, -1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 20.0, 0.0, 10.0),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : pengumuman == null
                              ? const Center(
                                  child: Text('Pengumuman tidak ditemukan.'))
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20.0, 0.0, 20.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFE4E4E4),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 10.0, 20.0, 10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  '[${pengumuman['kategori'] ?? 'Tanpa Kategori'}]',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color: const Color(
                                                            0xFFFF0000),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    pengumuman['judul'] ??
                                                        'Judul Tidak Tersedia',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20.0, 0.0, 20.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFE4E4E4),
                                            ),
                                          ),
                                          alignment: const AlignmentDirectional(
                                              0.0, 1.0),
                                          child: Text(
                                            pengumuman['isi'] ??
                                                'Tidak ada konten.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 10.0)),
                                  ),
                                ),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.bottomBarPengumumanModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const BottomBarPengumumanWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
