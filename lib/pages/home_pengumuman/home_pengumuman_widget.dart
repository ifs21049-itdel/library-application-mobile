import '/components/bottom_bar_pengumuman_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'home_pengumuman_model.dart';
export 'home_pengumuman_model.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePengumumanModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    fetchPengumuman();
  }

  Future<void> fetchPengumuman() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/pengumuman/'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data from API: $data'); // Cetak data yang diterima dari API

        if (data['data'] != null) {
          setState(() {
            pengumuman = data['data'];
            isLoading = false;
          });
        } else {
          print('Key "data" not found in API response');
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
                                  color: const Color(0xFFD9D9D9),
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
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
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
                    ),
                  ),
                ),

                // Daftar Pengumuman
                Flexible(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : pengumuman.isEmpty
                          ? Center(child: Text('Tidak ada pengumuman.'))
                          : ListView.builder(
                              itemCount: pengumuman.length,
                              itemBuilder: (context, index) {
                                final item = pengumuman[index];
                                return InkWell(
                                  onTap: () {
                                    context.pushNamed('DetailPengumuman');
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20.0, 10.0, 20.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '[${item['kategori']}]',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color:
                                                      const Color(0xFFFF0000),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              item['judul'],
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ].divide(const SizedBox(width: 10.0)),
                                      ),
                                    ),
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
