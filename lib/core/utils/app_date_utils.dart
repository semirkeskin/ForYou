class AppDateUtils {
  AppDateUtils._();

  /// Sabit referans noktasi: 2025-01-01 UTC.
  /// Daily note secimi bu epoch'a gore deterministik calisir.
  static final DateTime epoch = DateTime.utc(2025, 1, 1);

  /// Verilen [now] degerine gore epoch'tan bu yana gecen tam gun sayisi.
  /// Saat dilimi kaymasini engellemek icin UTC uzerinden hesaplanir.
  static int daysSinceEpoch([DateTime? now]) {
    final reference = (now ?? DateTime.now()).toUtc();
    return reference.difference(epoch).inDays;
  }

  /// Deterministik gunluk index. Liste sonuna gelindiginde basa sarar.
  static int dailyIndex(int listLength, [DateTime? now]) {
    if (listLength <= 0) return 0;
    final days = daysSinceEpoch(now);
    final mod = days % listLength;
    return mod < 0 ? mod + listLength : mod;
  }

  /// Hedef tarihe kalan sure. Negatifse tarih gecmistir.
  static Duration remaining(DateTime target, [DateTime? now]) {
    final reference = now ?? DateTime.now();
    return target.difference(reference);
  }
}
