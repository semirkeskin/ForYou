import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  static const String _kIntroSeen = 'intro_seen';
  static const String _kRecentLoveReasonIds = 'recent_love_reason_ids';
  static const String _kCustomBackgroundPath = 'custom_background_path';
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
}
