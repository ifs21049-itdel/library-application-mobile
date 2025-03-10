import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/config.dart';
import 'dart:convert';
import 'halaman_tugas_akhir_bioproses_model.dart'; // Adjust the import according to your project structure
import 'package:library_application/pages/detail_tugas_akhir/detail_tugas_akhir_widget.dart'; // Import the DetailTugasAkhirWidget

class HalamanTugasAkhirBioprosesWidget extends StatefulWidget {
  const HalamanTugasAkhirBioprosesWidget({super.key});

  @override
  State<HalamanTugasAkhirBioprosesWidget> createState() =>
      _HalamanTugasAkhirBioprosesWidgetState();
}

class _HalamanTugasAkhirBioprosesWidgetState
    extends State<HalamanTugasAkhirBioprosesWidget>
    with TickerProviderStateMixin {
  late HalamanTugasAkhirBioprosesModel _model;
  List<Thesis> _bioprosesList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HalamanTugasAkhirBioprosesModel();
    _model.tabBarController = TabController(length: 1, vsync: this);
    fetchThesisData(); // Fetch initial data for Bioproses
  }

  Future<void> fetchThesisData() async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/api/tugasakhir/by-program?fakultas=FTB&prodi=Bioproses'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        _bioprosesList = data.map((thesis) => Thesis.fromJson(thesis)).toList();
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
                        'Tugas Akhir Bioproses',
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
                  Tab(text: 'Bioproses'),
                ],
                onTap: (index) {
                  // Fetch data based on the selected tab
                  if (index == 0) {
                    fetchThesisData(); // Fetch data for Bioproses
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    // Display Bioproses data
                    _buildThesisList(_bioprosesList),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailTugasAkhirWidget(
                      id: thesis.id
                          .toString(), // Ensure thesis ID is passed correctly
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
