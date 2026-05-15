import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  static const String _kIntroSeen = 'intro_seen';
  static const String _kRecentLoveReasonIds = 'recent_love_reason_ids';
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

  /// Yeni gosterilen ID'yi pencereye ekler, en eskiyi atar.
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
}
