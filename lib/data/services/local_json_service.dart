import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants/asset_paths.dart';
import '../models/app_config.dart';
import '../models/daily_note.dart';
import '../models/love_reason.dart';
import '../models/memory_item.dart';
import '../models/surprise_box.dart';

class LocalJsonService {
  const LocalJsonService();

  Future<AppConfig> loadAppConfig() async {
    final raw = await _loadString(AssetPaths.appConfig);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return AppConfig.fromJson(map);
  }

  Future<List<DailyNote>> loadDailyNotes() async {
    return _loadList(AssetPaths.dailyNotes, DailyNote.fromJson);
  }

  Future<List<LoveReason>> loadLoveReasons() async {
    return _loadList(AssetPaths.loveReasons, LoveReason.fromJson);
  }

  Future<List<MemoryItem>> loadMemories() async {
    return _loadList(AssetPaths.memories, MemoryItem.fromJson);
  }

  Future<List<SurpriseBox>> loadSurpriseBoxes() async {
    return _loadList(AssetPaths.surpriseBoxes, SurpriseBox.fromJson);
  }

  Future<String> _loadString(String path) async {
    return rootBundle.loadString(path);
  }

  Future<List<T>> _loadList<T>(
    String path,
    T Function(Map<String, dynamic>) mapper,
  ) async {
    final raw = await _loadString(path);
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(mapper)
        .toList(growable: false);
  }
}
