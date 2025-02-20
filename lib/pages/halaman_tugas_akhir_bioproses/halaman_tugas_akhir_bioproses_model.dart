import '/flutter_flow/flutter_flow_util.dart';
import 'halaman_tugas_akhir_bioproses_widget.dart'
    show HalamanTugasAkhirBioprosesWidget;
import 'package:flutter/material.dart';

class HalamanTugasAkhirBioprosesModel
    extends FlutterFlowModel<HalamanTugasAkhirBioprosesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
