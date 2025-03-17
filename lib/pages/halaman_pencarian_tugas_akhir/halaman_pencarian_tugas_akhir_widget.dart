import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/index.dart';

import '../../config.dart';

export 'halaman_pencarian_tugas_akhir_model.dart';

class HalamanPencarianTugasAkhirWidget extends StatefulWidget {
  const HalamanPencarianTugasAkhirWidget({super.key});

  @override
  State<HalamanPencarianTugasAkhirWidget> createState() =>
      _HalamanPencarianTugasAkhirWidgetState();
}

class _HalamanPencarianTugasAkhirWidgetState
    extends State<HalamanPencarianTugasAkhirWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> tugasAkhir = [];
  bool isLoading = true;

  Future<void> fetchTugasAkhir({String search = ''}) async {
    try {
      final uri = Uri.parse('$apiUrl/api/tugasakhir/get-all');

      final Map<String, dynamic> requestBody = {
        'judul': _searchController.text,
      };

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
              Expanded(
                  child: TextField(
                      controller: _searchController,
                      onSubmitted: (value) {
                        fetchTugasAkhir(search: value);
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Search book',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                tugasAkhir = [];
                              });
                            },
                          )))),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
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
    )));
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
