import '/flutter_flow/flutter_flow_util.dart';
import 'halaman_pencarian_tugas_akhir_widget.dart'
    show HalamanPencarianTugasAkhirWidget;
import 'package:flutter/material.dart';

class HalamanPencarianTugasAkhirModel
    extends FlutterFlowModel<HalamanPencarianTugasAkhirWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;
  String? Function(BuildContext, String?)? searchTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchTextController?.dispose();
  }
}
