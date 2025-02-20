import '/components/bottom_bar_pengumuman_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_pengumuman_widget.dart' show HomePengumumanWidget;
import 'package:flutter/material.dart';

class HomePengumumanModel extends FlutterFlowModel<HomePengumumanWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for BottomBarPengumuman component.
  late BottomBarPengumumanModel bottomBarPengumumanModel;

  @override
  void initState(BuildContext context) {
    bottomBarPengumumanModel =
        createModel(context, () => BottomBarPengumumanModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    bottomBarPengumumanModel.dispose();
  }
}
