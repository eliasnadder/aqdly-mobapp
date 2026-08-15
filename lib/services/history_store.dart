import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/analysis_models.dart';

class HistoryStore {
  static const _key = 'analysis_history';
  static const _maxEntries = 20;

  final SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();

  HistoryStore(this._prefs);

  static Future<HistoryStore> create({SharedPreferences? prefs}) async {
    prefs ??= await SharedPreferences.getInstance();
    return HistoryStore(prefs);
  }

  Future<List<HistoryEntry>> list() async {
    final jsonList = _prefs.getStringList(_key);
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }
    return jsonList
        .map((jsonString) =>
            HistoryEntry.fromJson(jsonDecode(jsonString) as Map<String, dynamic>))
        .toList();
  }

  Future<HistoryEntry?> get(String id) async {
    final entries = await list();
    try {
      return entries.firstWhere((entry) => entry.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<HistoryEntry> save(AnalysisResult result) async {
    final entry = HistoryEntry(
      id: _uuid.v4(),
      savedAt: DateTime.now(),
      result: result,
    );

    final current = await list();
    current.insert(0, entry);

    if (current.length > _maxEntries) {
      current.removeRange(_maxEntries, current.length);
    }

    final jsonList = current.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_key, jsonList);

    return entry;
  }

  Future<void> delete(String id) async {
    final current = await list();
    current.removeWhere((entry) => entry.id == id);
    final jsonList = current.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_key, jsonList);
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}