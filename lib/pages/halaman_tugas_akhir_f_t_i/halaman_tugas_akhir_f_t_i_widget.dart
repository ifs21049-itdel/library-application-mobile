import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/config.dart';
import 'dart:convert';
import '../detail_tugas_akhir/detail_tugas_akhir_widget.dart';
import '../halaman_pencarian_tugas_akhir/halaman_pencarian_tugas_akhir_widget.dart';
import 'halaman_tugas_akhir_f_t_i_model.dart'; // Adjust the import according to your project structure

class HalamanTugasAkhirFTIWidget extends StatefulWidget {
  const HalamanTugasAkhirFTIWidget({super.key});

  @override
  State<HalamanTugasAkhirFTIWidget> createState() =>
      _HalamanTugasAkhirFTIWidgetState();
}

class _HalamanTugasAkhirFTIWidgetState extends State<HalamanTugasAkhirFTIWidget>
    with TickerProviderStateMixin {
  late HalamanTugasAkhirFTIModel _model;
  List<Thesis> _manajemenRekayasaList = [];
  List<Thesis> _teknikMetalurgiList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HalamanTugasAkhirFTIModel();
    _model.tabBarController = TabController(length: 2, vsync: this);
    fetchThesisData(
        'Manajemen Rekayasa'); // Fetch initial data for Manajemen Rekayasa
  }

  Future<void> fetchThesisData(String program) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/api/tugasakhir/by-program?fakultas=FTI&prodi=$program'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        if (program == 'Manajemen Rekayasa') {
          _manajemenRekayasaList =
              data.map((thesis) => Thesis.fromJson(thesis)).toList();
        } else if (program == 'Teknik Metalurgi') {
          _teknikMetalurgiList =
              data.map((thesis) => Thesis.fromJson(thesis)).toList();
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
                        'Tugas Akhir FTI',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => HalamanPencarianTugasAkhirWidget()));
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
                  Tab(text: 'Manajemen Rekayasa'),
                  Tab(text: 'Teknik Metalurgi'),
                ],
                onTap: (index) {
                  // Fetch data based on the selected tab
                  if (index == 0) {
                    fetchThesisData('Manajemen Rekayasa');
                  } else if (index == 1) {
                    fetchThesisData('Teknik Metalurgi');
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    // Display Manajemen Rekayasa data
                    _buildThesisList(_manajemenRekayasaList),
                    // Display Teknik Metalurgi data
                    _buildThesisList(_teknikMetalurgiList),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailTugasAkhirWidget(
                      id: thesis.id.toString(), // Kirim ID sebagai string
                    ),
                  ),
                );
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
