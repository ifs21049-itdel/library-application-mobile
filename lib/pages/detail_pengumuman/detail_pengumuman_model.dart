import '/components/bottom_bar_pengumuman_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'detail_pengumuman_widget.dart' show DetailPengumumanWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetailPengumumanModel extends FlutterFlowModel<DetailPengumumanWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for BottomBarPengumuman component.
  late BottomBarPengumumanModel bottomBarPengumumanModel;

  @override
  void initState(BuildContext context) {
    bottomBarPengumumanModel =
        createModel(context, () => BottomBarPengumumanModel());
  }

  @override
  void dispose() {
    bottomBarPengumumanModel.dispose();
  }
}
