import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  Future<void> saveBookHistory(String lastSearch) async {
    final pref = await SharedPreferences.getInstance();
    final String? tempHistory = pref.getString('recentBookHistory');

    if (tempHistory != null) {
      List<dynamic> tempHistoryList = json.decode(tempHistory);

      tempHistoryList.add(lastSearch);

      await pref.setString('recentBookHistory', json.encode(tempHistoryList));
    } else {
      await pref.setString('recentBookHistory', json.encode([lastSearch]));
    }
  }

  Future<String?> getBookHistory() async {
    final pref = await SharedPreferences.getInstance();
    final String? tempHistory = pref.getString('recentBookHistory');

    return tempHistory;
  }

  void removeBookHistory(String judul) async {
    final pref = await SharedPreferences.getInstance();
    final String? historyString = pref.getString('recentBookHistory');
    if (historyString != null) {
      List<dynamic> tempHistory = json.decode(historyString);

      tempHistory.removeWhere((item) => item == judul);

      await pref.setString('recentBookHistory', json.encode(tempHistory));
    } else {
      debugPrint('Tidak ada data untuk dihapus');
    }
  }

  Future<void> saveTugasAkhirHistory(String lastSearch) async {
    final pref = await SharedPreferences.getInstance();
    final String? tempHistory = pref.getString('recentTugasAkhirHistory');

    if (tempHistory != null) {
      List<dynamic> tempHistoryList = json.decode(tempHistory);

      tempHistoryList.add(lastSearch);

      await pref.setString(
          'recentTugasAkhirHistory', json.encode(tempHistoryList));
    } else {
      await pref.setString(
          'recentTugasAkhirHistory', json.encode([lastSearch]));
    }
  }

  Future<String?> getTugasAkhirHistory() async {
    final pref = await SharedPreferences.getInstance();
    final String? tempHistory = pref.getString('recentTugasAkhirHistory');

    return tempHistory;
  }

  void removeTugasAkhirHistory(String judul) async {
    final pref = await SharedPreferences.getInstance();
    final String? historyString = pref.getString('recentTugasAkhirHistory');
    if (historyString != null) {
      List<dynamic> tempHistory = json.decode(historyString);

      tempHistory.removeWhere((item) => item == judul);

      await pref.setString('recentTugasAkhirHistory', json.encode(tempHistory));
    } else {
      debugPrint('Tidak ada data untuk dihapus');
    }
  }
}
