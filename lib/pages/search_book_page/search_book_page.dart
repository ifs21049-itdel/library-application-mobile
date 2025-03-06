import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../detail_buku/detail_buku_widget.dart';

class SearchBookPage extends StatefulWidget {
  const SearchBookPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchBookPage();
  }
}

class _SearchBookPage extends State<SearchBookPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchBooks({String search = ''}) async {
    try {
      // Menambahkan parameter pencarian jika tersedia
      final uri = Uri.parse('$apiUrl/api/book').replace(
          queryParameters: search.isNotEmpty ? {'search': search} : {});

      final response = await http.get(uri);

      debugPrint('Body : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          books = data['data'];
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
                        fetchBooks(search: value);
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
                                books = [];
                              });
                            },
                          )))),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text(_searchController.text.isEmpty
              ? 'Tidak ada pencarian'
              : 'Menampilkan ${books.length} untuk pencarian: ${_searchController.text}'),
        ),
        Expanded(
            child: ListView(
          children: books.map((book) {
            return BookItem(judul: book['judul'], pengarang: book['penulis'], id: book['id'],);
          }).toList(),
        ))
      ],
    )));
  }
}

class BookItem extends StatelessWidget {
  final String judul;
  final String pengarang;
  final int id;

  const BookItem({
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
            builder: (context) => DetailBukuWidget(
              bookId: id.toString(),
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
