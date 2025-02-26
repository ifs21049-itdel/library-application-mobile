import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_application/flutter_flow/flutter_flow_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;

  Future<void> loginUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://103.167.217.134/api/jwt-api/do-auth'),
        body: {
          'username': username,
          'password': password,
        },
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['result'] == true) {
        if (data['user']['role'] == 'Mahasiswa') {
          // Simpan data user ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(data['user']));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login berhasil')),
          );
          context.pushNamed('HomePage'); // Navigasi ke halaman utama
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login gagal. Akun tidak diizinkan.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login gagal. Periksa kembali kredensial.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Institut_Teknologi_Del.png',
                  width: 120.0,
                  height: 120.0,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FFButtonWidget(
                  onPressed: loginUser,
                  text: 'Login',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 40.0,
                    color: const Color(0xFF5B4D81),
                    textStyle: const TextStyle(color: Colors.white),
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
