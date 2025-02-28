import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:library_application/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteData();
}

class _CompleteData extends State<CompleteData> {
  final TextEditingController _name = TextEditingController();

  Future<void> postData() async {
    final url = Uri.parse(
        '${dotenv.env['API_URL']}/api/auth/complete-data'); // Ganti dengan URL API-mu
    final headers = {'Content-Type': 'application/json'};

    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> previousUserData =
        jsonDecode(prefs.getString('user_data')!);

    final body = jsonEncode(
        {'user_id': previousUserData['user_id'], 'name': _name.text});

    try {
      final response = await http.post(url, headers: headers, body: body);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.setString('user_data', jsonEncode(data['data'][0]));

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );

        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => const HomePageWidget()));
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/ask.png',
                  width: 250,
                ),
                const Text(
                  'Masukkan nama anda!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text('Your Name')),
                ),
                const SizedBox(
                  height: 16,
                ),
                FilledButton(
                    onPressed: postData,
                    child: const Text('Simpan dan Lanjutkan'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
