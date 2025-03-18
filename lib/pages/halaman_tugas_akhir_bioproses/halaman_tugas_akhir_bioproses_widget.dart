import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../halaman_pencarian_tugas_akhir/halaman_pencarian_tugas_akhir_widget.dart';

class HalamanTugasAkhirBioprosesWidget extends StatefulWidget {
  const HalamanTugasAkhirBioprosesWidget({super.key});

  @override
  State<HalamanTugasAkhirBioprosesWidget> createState() =>
      _HalamanTugasAkhirBioprosesWidgetState();
}

class _HalamanTugasAkhirBioprosesWidgetState
    extends State<HalamanTugasAkhirBioprosesWidget>
    with TickerProviderStateMixin {
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
    fetchTugasAkhir(prodi: 'Bioproses');
    _tabController = TabController(length: 1, vsync: this);

    // Listener untuk menangkap event ketika tab aktif
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          fetchTugasAkhir(prodi: 'Bioproses');
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
                          'Tugas Akhir Bioproses',
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
                            Text('Bioproses'),
                          ],
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          onTap: (index) {
                            // Fetch data based on the selected tab
                            if (index == 0) {
                              fetchTugasAkhir(prodi: 'Bioproses');
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
