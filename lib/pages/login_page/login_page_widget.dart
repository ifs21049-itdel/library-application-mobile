import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final String username = _model.textController1!.text;
    final String password = _model.textController2!.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua kolom')),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login berhasil')),
          );
          context.pushNamed('HomePage'); // Navigasi ke halaman utama
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login gagal. Akun tidak diizinkan.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal. Periksa kembali kredensial.')),
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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
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
                  controller: _model.textController1,
                  focusNode: _model.textFieldFocusNode1,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _model.textController2,
                  focusNode: _model.textFieldFocusNode2,
                  obscureText: !_model.passwordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _model.passwordVisibility
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _model.passwordVisibility =
                              !_model.passwordVisibility;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FFButtonWidget(
                  onPressed: loginUser, // Panggil fungsi login
                  text: 'Login',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 40.0,
                    color: const Color(0xFF5B4D81),
                    textStyle: TextStyle(color: Colors.white),
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
