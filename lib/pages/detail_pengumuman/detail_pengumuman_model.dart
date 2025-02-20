import '/components/bottom_bar_pengumuman_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'detail_pengumuman_widget.dart' show DetailPengumumanWidget;
import 'package:flutter/material.dart';

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
