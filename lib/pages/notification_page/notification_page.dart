import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar notifikasi statis
    final List<Map<String, String>> notifications = [
      {
        'title': 'Pemberitahuan 1',
        'body': 'Ini adalah isi dari notifikasi pertama.',
      },
      {
        'title': 'Pemberitahuan 2',
        'body': 'Ini adalah isi dari notifikasi kedua.',
      },
      {
        'title': 'Pemberitahuan 3',
        'body': 'Notifikasi ketiga hadir untuk Anda!',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: notifications.isEmpty
          ? const Center(child: Text('Tidak ada notifikasi'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final message = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(message['title'] ?? 'Tidak ada judul'),
                    subtitle: Text(message['body'] ?? 'Tidak ada isi'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Semua notifikasi dihapus (statis)')),
          );
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}
