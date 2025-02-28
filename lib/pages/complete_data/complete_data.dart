import 'package:flutter/material.dart';

class CompleteData extends StatefulWidget {
  const CompleteData({super.key});

  @override
  State<CompleteData> createState() => _CompleteData();
}

class _CompleteData extends State<CompleteData> {
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
                const TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text('Your Name')),
                ),
                const SizedBox(
                  height: 16,
                ),
                FilledButton(onPressed: () {}, child: const Text('Simpan dan Lanjutkan'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
