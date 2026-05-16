import 'package:shared_preferences/shared_preferences.dart';

import '../models/countdown_event.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  static const String _kIntroSeen = 'intro_seen';
  static const String _kRecentLoveReasonIds = 'recent_love_reason_ids';
  static const String _kCustomBackgroundPath = 'custom_background_path';
  static const String _kCountdownEvents = 'countdown_events';
  static const String _kRelationshipStart = 'relationship_start_date';
  static const int _recentWindow = 3;

  final SharedPreferences _prefs;

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  bool get introSeen => _prefs.getBool(_kIntroSeen) ?? false;

  Future<void> setIntroSeen(bool value) async {
    await _prefs.setBool(_kIntroSeen, value);
  }

  List<int> get recentLoveReasonIds {
    final raw = _prefs.getStringList(_kRecentLoveReasonIds) ?? const [];
    return raw
        .map(int.tryParse)
        .whereType<int>()
        .toList(growable: false);
  }

  Future<void> pushRecentLoveReason(int id) async {
    final current = recentLoveReasonIds.toList();
    current.remove(id);
    current.add(id);
    while (current.length > _recentWindow) {
      current.removeAt(0);
    }
    await _prefs.setStringList(
      _kRecentLoveReasonIds,
      current.map((e) => e.toString()).toList(),
    );
  }

  /// Kullanicinin sectigi ozel arka plan dosyasinin yerel yolu.
  /// Null ise varsayilan kiraz pattern kullanilir.
  String? get customBackgroundPath {
    final raw = _prefs.getString(_kCustomBackgroundPath);
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }

  Future<void> setCustomBackgroundPath(String? path) async {
    if (path == null || path.isEmpty) {
      await _prefs.remove(_kCustomBackgroundPath);
    } else {
      await _prefs.setString(_kCustomBackgroundPath, path);
    }
  }

  /// Kullanicinin ekledigi geri sayim eventleri.
  List<CountdownEvent> get countdownEvents {
    return CountdownEvent.decodeList(_prefs.getString(_kCountdownEvents));
  }

  Future<void> saveCountdownEvents(List<CountdownEvent> events) async {
    if (events.isEmpty) {
      await _prefs.remove(_kCountdownEvents);
    } else {
      await _prefs.setString(
        _kCountdownEvents,
        CountdownEvent.encodeList(events),
      );
    }
  }

  Future<void> upsertCountdownEvent(CountdownEvent event) async {
    final current = countdownEvents.toList();
    final idx = current.indexWhere((e) => e.id == event.id);
    if (idx >= 0) {
      current[idx] = event;
    } else {
      current.add(event);
    }
    await saveCountdownEvents(current);
  }

  Future<void> removeCountdownEvent(String id) async {
    final current =
        countdownEvents.where((e) => e.id != id).toList(growable: false);
    await saveCountdownEvents(current);
  }

  /// Iliski baslangic tarihi — ana sayfada 'X gun' sayaci icin.
  DateTime? get relationshipStartDate {
    final raw = _prefs.getString(_kRelationshipStart);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setRelationshipStartDate(DateTime? date) async {
    if (date == null) {
      await _prefs.remove(_kRelationshipStart);
    } else {
      await _prefs.setString(_kRelationshipStart, date.toIso8601String());
    }
  }
}
