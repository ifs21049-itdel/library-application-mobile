import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_theme.dart';

class InformasiAkunModalWidget extends StatefulWidget {
  const InformasiAkunModalWidget({super.key});

  @override
  State<InformasiAkunModalWidget> createState() =>
      _InformasiAkunModalWidgetState();
}

class _InformasiAkunModalWidgetState extends State<InformasiAkunModalWidget> {
  Map<String, dynamic>? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    if (userData != null) {
      final parsedUser = jsonDecode(userData);
      setState(() {
        currentUser = parsedUser;
        isLoading = false;
      });

      // Ambil data terbaru dari API
      await _fetchUserFromApi(parsedUser['id']);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserFromApi(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/api/users/$userId'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('data')) {
          final data = responseData['data'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(data));

          setState(() {
            currentUser = data;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : currentUser == null
                  ? const Center(child: Text("Data pengguna tidak tersedia"))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            Icons.person, 'Nama', currentUser?['name']),
                        _buildInfoRow(
                            Icons.email, 'Email', currentUser?['email']),
                        _buildInfoRow(
                            Icons.person, 'Username', currentUser?['username']),
                        _buildInfoRow(
                            Icons.school, 'Role', currentUser?['role']),
                        _buildInfoRow(
                            Icons.verified,
                            'Status',
                            currentUser?['status'] == 1
                                ? 'Aktif'
                                : 'Tidak Aktif'),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, dynamic value) {
    return Row(
      children: [
        Icon(icon, color: FlutterFlowTheme.of(context).primary),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text('$title: ${value ?? "Tidak tersedia"}'), // Menangani null
        ),
      ],
    );
  }
}
