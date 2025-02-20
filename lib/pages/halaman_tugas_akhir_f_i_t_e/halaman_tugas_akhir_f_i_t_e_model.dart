import '/flutter_flow/flutter_flow_util.dart';
import 'halaman_tugas_akhir_f_i_t_e_widget.dart'
    show HalamanTugasAkhirFITEWidget;
import 'package:flutter/material.dart';

class HalamanTugasAkhirFITEModel
    extends FlutterFlowModel<HalamanTugasAkhirFITEWidget> {
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
