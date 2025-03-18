import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/index.dart';

class HalamanTugasAkhirFITEWidget extends StatefulWidget {
  const HalamanTugasAkhirFITEWidget({super.key});

  @override
  State<HalamanTugasAkhirFITEWidget> createState() =>
      _HalamanTugasAkhirFITEWidgetState();
}

class _HalamanTugasAkhirFITEWidgetState
    extends State<HalamanTugasAkhirFITEWidget> with TickerProviderStateMixin {
  // late HalamanTugasAkhirFITEModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> tugasAkhir = [];
  bool isLoading = true;
  late TabController _tabController;

  Future<void> fetchTugasAkhir({String prodi = ''}) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/api/tugasakhir/get-all');

      final Map<String, dynamic> requestBody = {
        'prodi': prodi,
      };

      debugPrint(requestBody.toString());

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tugasAkhir = data['data'];
          isLoading = false;
        });
      } else {
        debugPrint('Failed to load books: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTugasAkhir(prodi: 'Teknik Informatika');
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          fetchTugasAkhir(prodi: 'Teknik Informatika');
        } else if (_tabController.index == 1) {
          fetchTugasAkhir(prodi: 'Sistem Informasi');
        } else if (_tabController.index == 2) {
          fetchTugasAkhir(prodi: 'Teknik Elektro');
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
          child: Container(
            color: Colors.grey[100],
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 64.0,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20.0, 0.0, 20.0, 0.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Tugas Akhir FITE',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        HalamanPencarianTugasAkhirWidget()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Container(
                        color: Colors.white,
                        child: TabBar(
                          tabs: [
                            Text('Informatika'),
                            Text('Sistem Informasi'),
                            Text('Teknik Elektro'),
                          ],
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          onTap: (index) {
                            // Fetch data based on the selected tab
                            if (index == 0) {
                              fetchTugasAkhir(prodi: 'Teknik Informatika');
                            } else if (index == 1) {
                              fetchTugasAkhir(prodi: 'Sistem Informasi');
                            } else if (index == 2) {
                              fetchTugasAkhir(prodi: 'Teknik Elektro');
                            }
                          },
                        ))),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      children: tugasAkhir.map((tugasAkhirItem) {
                        return TugasAkhirItem(
                          judul: tugasAkhirItem['judul'],
                          pengarang: tugasAkhirItem['penulis'],
                          id: tugasAkhirItem['id'],
                        );
                      }).toList(),
                    ),
                    ListView(
                      children: tugasAkhir.map((tugasAkhirItem) {
                        return TugasAkhirItem(
                          judul: tugasAkhirItem['judul'],
                          pengarang: tugasAkhirItem['penulis'],
                          id: tugasAkhirItem['id'],
                        );
                      }).toList(),
                    ),
                    ListView(
                      children: tugasAkhir.map((tugasAkhirItem) {
                        return TugasAkhirItem(
                          judul: tugasAkhirItem['judul'],
                          pengarang: tugasAkhirItem['penulis'],
                          id: tugasAkhirItem['id'],
                        );
                      }).toList(),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TugasAkhirItem extends StatelessWidget {
  final String judul;
  final String pengarang;
  final int id;

  const TugasAkhirItem({
    super.key,
    required this.judul,
    required this.pengarang,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTugasAkhirWidget(
              id: id.toString(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/document.png',
                  width: 50,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pengarang,
                        style: const TextStyle(color: Colors.grey),
                      ),
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
}
