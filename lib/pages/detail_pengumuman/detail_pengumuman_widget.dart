import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart';
import 'package:intl/intl.dart';

class DetailPengumumanWidget extends StatefulWidget {
  final String id;
  const DetailPengumumanWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPengumumanWidget> createState() => _DetailPengumumanWidgetState();
}

class _DetailPengumumanWidgetState extends State<DetailPengumumanWidget> {
  dynamic pengumuman;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPengumuman();
  }

  Future<void> fetchPengumuman() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/api/pengumuman/${widget.id}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data'); // Log the response

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final pengumumanData = data['data'];
          setState(() {
            pengumuman = pengumumanData;

            // Pastikan file adalah List
            if (pengumumanData['file'] != null &&
                pengumumanData['file'] is List) {
              // Tidak perlu mem-parsing lagi, sudah dalam bentuk List
            } else {
              pengumumanData['file'] =
                  []; // Set default value if file is null or not a list
            }

            isLoading = false;
          });
        } else {
          print('Invalid data format from API: ${response.body}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Failed to load pengumuman: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching pengumuman: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk meminta izin penyimpanan
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Fungsi untuk mengunduh file
  Future<void> downloadFile(String fileUrl, String fileName) async {
    try {
      // Minta izin penyimpanan
      await requestStoragePermission();

      // Dapatkan direktori penyimpanan eksternal (internal storage)
      Directory? directory = await getExternalStorageDirectory();

      // Buat path khusus ke folder Download
      String downloadPath = '${directory!.path}/Download';

      // Buat folder Download jika belum ada
      final downloadDir = Directory(downloadPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Path lengkap untuk menyimpan file
      String savePath = '$downloadPath/$fileName';

      // Unduh file menggunakan Dio
      Dio dio = Dio();
      await dio.download(
        fileUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                "Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File berhasil diunduh ke $savePath")),
      );
    } catch (e) {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pengumuman'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pengumuman == null
              ? const Center(child: Text('Pengumuman tidak ditemukan.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[${pengumuman['kategori'] ?? 'Tanpa Kategori'}]',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pengumuman['judul'] ?? 'Judul Tidak Tersedia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pengumuman['isi'] ?? 'Tidak ada konten.',
                        style: TextStyle(fontSize: 16),
                      ),
                      // Tambahkan ini setelah menampilkan isi pengumuman
                      const SizedBox(height: 16),
                      Text(
                        'Dibuat pada: ${_formatDate(pengumuman['created_at'])}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (pengumuman['file'] != null &&
                          pengumuman['file'] is List)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'File Terlampir:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...(pengumuman['file'] as List<dynamic>)
                                .map((file) {
                              return ListTile(
                                title: Text(file['originalFilename']),
                                subtitle: Text(file['fileSize']),
                                trailing: IconButton(
                                  icon: Icon(Icons.download),
                                  onPressed: () {
                                    downloadFile(
                                      '$apiUrl/${file['location']}', // URL file
                                      file['originalFilename'],
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }
}

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy, HH:mm').format(date);
  } catch (e) {
    return '-';
  }
}
