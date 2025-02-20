import '/components/bottom_bar_profile_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pinjam_buku_widget.dart' show PinjamBukuWidget;
import 'package:flutter/material.dart';

class PinjamBukuModel extends FlutterFlowModel<PinjamBukuWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for BottomBarProfile component.
  late BottomBarProfileModel bottomBarProfileModel;

  @override
  void initState(BuildContext context) {
    bottomBarProfileModel = createModel(context, () => BottomBarProfileModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    tabBarController?.dispose();
    bottomBarProfileModel.dispose();
  }
}
