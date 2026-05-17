import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants/asset_paths.dart';
import '../models/app_config.dart';
import '../models/daily_note.dart';
import '../models/love_reason.dart';
import '../models/love_ping.dart';
import '../models/memory_item.dart';
import '../models/song_item.dart';
import '../models/special_hour_message.dart';
import '../models/surprise_box.dart';
import '../models/voice_message.dart';

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

  Future<List<SongItem>> loadSongs() async {
    return _loadList(AssetPaths.songs, SongItem.fromJson);
  }

  Future<List<VoiceMessage>> loadVoiceMessages() async {
    return _loadList(AssetPaths.voiceMessages, VoiceMessage.fromJson);
  }

  Future<SpecialHourMessage> loadSpecialHourMessage() async {
    try {
      final raw = await _loadString(AssetPaths.specialHours);
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return SpecialHourMessage.fromJson(map);
    } on Exception {
      return SpecialHourMessage.empty;
    }
  }

  Future<List<LovePing>> loadLovePings() async {
    try {
      return _loadList(AssetPaths.lovePings, LovePing.fromJson);
    } on Exception {
      return const [];
    }
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
