import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/serie.dart';

class SerieController {
  static const String _keySeries = 'series';

  Future<void> saveSeries(List<Serie> series) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keySeries, jsonEncode(series.map((e) => e.toMap()).toList()));
  }

  Future<List<Serie>> getSeries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keySeries);
    if (data != null) {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => Serie.fromMap(e)).toList();
    }
    return [];
  }

  void registrarVitoria(Serie serie) {
    serie.vitorias++;
  }
}
