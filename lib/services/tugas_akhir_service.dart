import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class TugasAkhirService {
  Future<http.Response?> fetchBooks(
      String? search, String? fakultas, String? prodi) async {
    try {
      // Menambahkan parameter pencarian jika tersedia
      final uri = Uri.parse('$apiUrl/api/tugasakhir').replace(queryParameters: {
        'search': search ?? '',
        'fakultas': fakultas ?? '',
        'prodi': prodi ?? '',
      });

      final response = await http.get(uri);

      return response;
    } catch (e) {
      debugPrint('Error fetching books: $e');
      return null;
    }
  }
}
