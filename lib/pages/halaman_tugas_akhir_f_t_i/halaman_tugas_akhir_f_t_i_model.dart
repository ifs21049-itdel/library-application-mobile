import '/flutter_flow/flutter_flow_util.dart';
import 'halaman_tugas_akhir_f_t_i_widget.dart' show HalamanTugasAkhirFTIWidget;
import 'package:flutter/material.dart';

class HalamanTugasAkhirFTIModel
    extends FlutterFlowModel<HalamanTugasAkhirFTIWidget> {
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
