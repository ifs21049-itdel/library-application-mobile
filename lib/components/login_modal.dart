import 'package:flutter/material.dart';
import 'package:library_application/pages/home_page/home_page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

Map<String, dynamic>? currentUser;

void showLoginModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Diperlukan'),
        content: Text('Anda harus login untuk melanjutkan peminjaman buku.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_data');

              if (currentUser == null) {
                context.pushNamed('LoginPage');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => HomePageWidget()),
                );
              }
            },
            child: Text('Login'),
          ),
        ],
      );
    },
  );
}
