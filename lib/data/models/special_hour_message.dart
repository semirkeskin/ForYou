/// Saat-dakika eslesmesi anlarinda (10:10 ... 02:02) gosterilecek metin.
class SpecialHourMessage {
  const SpecialHourMessage({required this.title, required this.body});

  final String title;
  final String body;

  bool get isEmpty => title.isEmpty && body.isEmpty;

  factory SpecialHourMessage.fromJson(Map<String, dynamic> json) {
    return SpecialHourMessage(
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }

  static const SpecialHourMessage empty =
      SpecialHourMessage(title: '', body: '');
}
