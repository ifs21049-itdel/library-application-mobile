import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/config.dart';
import 'package:library_application/index.dart';
import 'dart:convert';
import 'halaman_tugas_akhir_f_i_t_e_model.dart'; // Adjust the import according to your project structure
import 'package:library_application/pages/detail_tugas_akhir/detail_tugas_akhir_widget.dart'; // Import the DetailTugasAkhirWidget

class HalamanTugasAkhirFITEWidget extends StatefulWidget {
  const HalamanTugasAkhirFITEWidget({super.key});

  @override
  State<HalamanTugasAkhirFITEWidget> createState() =>
      _HalamanTugasAkhirFITEWidgetState();
}

class _HalamanTugasAkhirFITEWidgetState
    extends State<HalamanTugasAkhirFITEWidget> with TickerProviderStateMixin {
  late HalamanTugasAkhirFITEModel _model;
  List<Thesis> _informatikaList = [];
  List<Thesis> _sistemInformasiList = [];
  List<Thesis> _teknikElektroList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HalamanTugasAkhirFITEModel();
    _model.tabBarController = TabController(length: 3, vsync: this);
    fetchThesisData('Informatika'); // Fetch initial data for Informatika
  }

  Future<void> fetchThesisData(String program) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/api/tugasakhir/by-program?fakultas=FITE&prodi=$program'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        if (program == 'Informatika') {
          _informatikaList =
              data.map((thesis) => Thesis.fromJson(thesis)).toList();
        } else if (program == 'Sistem Informasi') {
          _sistemInformasiList =
              data.map((thesis) => Thesis.fromJson(thesis)).toList();
        } else if (program == 'Teknik Elektro') {
          _teknikElektroList =
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
                        'Tugas Akhir FITE',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => HalamanPencarianTugasAkhirWidget()));
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
                  Tab(text: 'Informatika'),
                  Tab(text: 'Sistem Informasi'),
                  Tab(text: 'Teknik Elektro'),
                ],
                onTap: (index) {
                  // Fetch data based on the selected tab
                  if (index == 0) {
                    fetchThesisData('Informatika');
                  } else if (index == 1) {
                    fetchThesisData('Sistem Informasi');
                  } else if (index == 2) {
                    fetchThesisData('Teknik Elektro');
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    // Display Informatika data
                    _buildThesisList(_informatikaList),
                    // Display Sistem Informasi data
                    _buildThesisList(_sistemInformasiList),
                    // Display Teknik Elektro data
                    _buildThesisList(_teknikElektroList),
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
