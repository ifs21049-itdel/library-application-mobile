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

class Thesis {
  final int id;
  final String title;
  final String author;
  final String supervisor;
  final String examiner;
  final String faculty;
  final String program;
  final String keywords;
  final String year;
  final String location;
  final String abstractText;
  final String createdAt;
  final String updatedAt;

  Thesis({
    required this.id,
    required this.title,
    required this.author,
    required this.supervisor,
    required this.examiner,
    required this.faculty,
    required this.program,
    required this.keywords,
    required this.year,
    required this.location,
    required this.abstractText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Thesis.fromJson(Map<String, dynamic> json) {
    return Thesis(
      id: json['id'],
      title: json['judul'],
      author: json['penulis'],
      supervisor: json['pembimbing'],
      examiner: json['penguji'],
      faculty: json['fakultas'],
      program: json['prodi'],
      keywords: json['katakunci'],
      year: json['tahun'],
      location: json['lokasi'],
      abstractText: json['abstrak'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
