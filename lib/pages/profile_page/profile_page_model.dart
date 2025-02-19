import '/components/bottom_bar_profile_widget.dart';
import '/components/informasi_akun_modal_widget.dart';
import '/components/staff_perpustakaan_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BottomBarProfile component.
  late BottomBarProfileModel bottomBarProfileModel;

  @override
  void initState(BuildContext context) {
    bottomBarProfileModel = createModel(context, () => BottomBarProfileModel());
  }

  @override
  void dispose() {
    bottomBarProfileModel.dispose();
  }
}
