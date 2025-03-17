import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/config.dart';

import '../detail_tugas_akhir/detail_tugas_akhir_widget.dart';
import '../halaman_pencarian_tugas_akhir/halaman_pencarian_tugas_akhir_widget.dart';
import 'halaman_tugas_akhir_vokasi_model.dart'; // Adjust the import according to your project structure

class HalamanTugasAkhirVokasiWidget extends StatefulWidget {
  const HalamanTugasAkhirVokasiWidget({super.key});

  @override
  State<HalamanTugasAkhirVokasiWidget> createState() =>
      _HalamanTugasAkhirVokasiWidgetState();
}

class _HalamanTugasAkhirVokasiWidgetState
    extends State<HalamanTugasAkhirVokasiWidget> with TickerProviderStateMixin {
  late HalamanTugasAkhirVokasiModel _model;
  List<dynamic> tugasAkhir = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = HalamanTugasAkhirVokasiModel();
    _model.tabBarController = TabController(length: 3, vsync: this);
    fetchTugasAkhir(
        prodi:
            'Teknik Informasi'); // Fetch initial data for Teknologi Informasi
  }

  Future<void> fetchTugasAkhir({String prodi = ''}) async {
    try {
      final uri = Uri.parse('$apiUrl/api/tugasakhir/get-all');

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
  void dispose() {
    _model.tabBarController?.dispose();
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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 64.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
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
                        'Tugas Akhir Vokasi',
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
                      )
                    ],
                  ),
                ),
              ),
              TabBar(
                controller: _model.tabBarController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Teknologi Informasi'),
                  Tab(text: 'Teknologi Komputer'),
                  Tab(text: 'Teknologi Rekayasa Perangkat Lunak'),
                ],
                onTap: (index) {
                  // Fetch data based on the selected tab
                  if (index == 0) {
                    fetchTugasAkhir(prodi: 'Teknik Informasi');
                  } else if (index == 1) {
                    fetchTugasAkhir(prodi: 'Teknik Komputer');
                  } else if (index == 2) {
                    fetchTugasAkhir(prodi: 'D4');
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    Expanded(
                        child: ListView(
                      children: tugasAkhir.map((tugasAkhirItem) {
                        return TugasAkhirItem(
                          judul: tugasAkhirItem['judul'],
                          pengarang: tugasAkhirItem['penulis'],
                          id: tugasAkhirItem['id'],
                        );
                      }).toList(),
                    )),
                    Expanded(
                        child: ListView(
                      children: tugasAkhir.map((tugasAkhirItem) {
                        return TugasAkhirItem(
                          judul: tugasAkhirItem['judul'],
                          pengarang: tugasAkhirItem['penulis'],
                          id: tugasAkhirItem['id'],
                        );
                      }).toList(),
                    )),
                    Expanded(
                        child: ListView(
                      children: tugasAkhir.map((tugasAkhirItem) {
                        return TugasAkhirItem(
                          judul: tugasAkhirItem['judul'],
                          pengarang: tugasAkhirItem['penulis'],
                          id: tugasAkhirItem['id'],
                        );
                      }).toList(),
                    ))
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
