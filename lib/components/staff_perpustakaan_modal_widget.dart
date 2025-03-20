import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'staff_perpustakaan_modal_model.dart';

export 'staff_perpustakaan_modal_model.dart';

class StaffPerpustakaanModalWidget extends StatefulWidget {
  const StaffPerpustakaanModalWidget({super.key});

  @override
  State<StaffPerpustakaanModalWidget> createState() =>
      _StaffPerpustakaanModalWidgetState();
}

class _StaffPerpustakaanModalWidgetState
    extends State<StaffPerpustakaanModalWidget> {
  late StaffPerpustakaanModalModel _model;

  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $email';
    }
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StaffPerpustakaanModalModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 1000, // Setengah layar
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 7.0,
              color: Color(0x2F1D2429),
              offset: Offset(0.0, 3.0),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Staff Perpustakaan',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Divider(
                height: 16.0,
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildStaffCard('Jesika Hutabarat',
                          'jesikahutabarat@gmail.com', '+62 812-6997-6520'),
                      _buildStaffCard('Trislevia Panggabean',
                          'trislevia@gmail.com', '+62 896-5746-8685'),
                      _buildStaffCard('Samuel Marpaung', 'samuel@gmail.com',
                          '+62 811-5678-4321'),
                      _buildStaffCard('Lidya Sihombing', 'lidya@gmail.com',
                          '+62 822-3456-7890'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(String name, String email, String phone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5.0,
              color: Color(0x2F1D2429),
              offset: Offset(0.0, 2.0),
            )
          ],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 4.0),
            // Text(
            //   email,
            //   style: FlutterFlowTheme.of(context).labelMedium.override(
            //         fontFamily: 'Inter',
            //         letterSpacing: 0.0,
            //       ),
            // ),
            RichText(
              text: TextSpan(
                text: email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _launchEmail(email),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              phone,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
