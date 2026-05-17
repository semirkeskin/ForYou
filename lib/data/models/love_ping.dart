/// Gun icinde belli saatlerde gonderilen ozlem/sevgi bildirimi.
class LovePing {
  const LovePing({
    required this.id,
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
  });

  final int id;
  final int hour;
  final int minute;
  final String title;
  final String body;

  bool get isEmpty => title.isEmpty && body.isEmpty;

  factory LovePing.fromJson(Map<String, dynamic> json) {
    final timeStr = (json['time'] as String?) ?? '00:00';
    final parts = timeStr.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return LovePing(
      id: json['id'] as int,
      hour: h.clamp(0, 23),
      minute: m.clamp(0, 59),
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }
}
