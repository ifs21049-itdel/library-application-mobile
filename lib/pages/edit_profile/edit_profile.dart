import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();

  File? _image; // Menyimpan gambar yang dipilih
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Simpan gambar yang dipilih
      });
    }
  }

  Future<void> takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _image = File(photo.path); // Simpan gambar yang diambil
      });
    }
  }

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      debugPrint(prefs.getString('user_data'));
      userData = prefs.getString('user_data') == null
          ? {}
          : jsonDecode(prefs.getString('user_data')!);
      _nameController.text = userData['name'];
    });
  }

  Future<void> updateUser() async {
    try {
      var uri = Uri.parse('${dotenv.env['API_URL']}/api/users');
      var request = http.MultipartRequest("PUT", uri);

      // Tambahkan data id dan name
      request.fields['id'] = '${userData['id']}';
      request.fields['name'] = _nameController.text;

      // Jika ada gambar, tambahkan ke request
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'picture',
          _image!.path,
        ));
      }

      // Kirim request
      final response = await request.send();
      final Map<String, dynamic> data = json.decode(await response.stream.bytesToString());

      if (!mounted) return;

      // Tampilkan AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(response.statusCode == 200 ? 'Sukses' : 'Gagal'),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => ProfilePageWidget()),
                    );
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint("Error updating user: $e");

      if (!mounted) return;

      // Tampilkan dialog error jika terjadi exception
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text("Terjadi kesalahan: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Profil',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 70,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: _image != null
                        ? Image.file(
                      _image!,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/me.png',
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: takePicture,
                        child: const Text("Ambil Foto"),
                      ),
                      TextButton(
                        onPressed: pickImage,
                        child: const Text("Pilih dari Galeri"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Your Name')),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: 800,
                    child: FilledButton(onPressed: updateUser, child: Text('Simpan')),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
