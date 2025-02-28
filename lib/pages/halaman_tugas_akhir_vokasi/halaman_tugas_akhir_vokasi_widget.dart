import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/config.dart';
import 'dart:convert';
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
  List<Thesis> _teknologiInformasiList = [];
  List<Thesis> _teknologiKomputerList = [];
  List<Thesis> _trplList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HalamanTugasAkhirVokasiModel();
    _model.tabBarController = TabController(length: 3, vsync: this);
    fetchThesisData(
        'Teknologi Informasi'); // Fetch initial data for Teknologi Informasi
  }

  Future<void> fetchThesisData(String program) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/api/tugasakhir/by-program?fakultas=Vokasi&prodi=$program'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        if (program == 'Teknologi Informasi') {
          _teknologiInformasiList =
              data.map((thesis) => Thesis.fromJson(thesis)).toList();
        } else if (program == 'Teknologi Komputer') {
          _teknologiKomputerList =
              data.map((thesis) => Thesis.fromJson(thesis)).toList();
        } else if (program == 'Teknologi Rekayasa Perangkat Lunak') {
          _trplList = data.map((thesis) => Thesis.fromJson(thesis)).toList();
        }
      });
    } else {
      throw Exception('Failed to load thesis data');
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
        key: scaffoldKey,
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
                          // Navigate to search page
                        },
                      ),
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
                    fetchThesisData('Teknologi Informasi');
                  } else if (index == 1) {
                    fetchThesisData('Teknologi Komputer');
                  } else if (index == 2) {
                    fetchThesisData('Teknologi Rekayasa Perangkat Lunak');
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    // Display Teknologi Informasi data
                    _buildThesisList(_teknologiInformasiList),
                    // Display Teknologi Komputer data
                    _buildThesisList(_teknologiKomputerList),
                    // Display TRPL data
                    _buildThesisList(_trplList),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThesisList(List<Thesis> thesisList) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          for (var thesis in thesisList) ...[
            Divider(thickness: 2.0),
            InkWell(
              onTap: () {
                // Navigate to detail page
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(Icons.feed, size: 50.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thesis.title,
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${thesis.program}, Tugas Akhir',
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
