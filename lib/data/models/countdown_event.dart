import 'dart:convert';

class CountdownEvent {
  const CountdownEvent({
    required this.id,
    required this.title,
    required this.targetDate,
  });

  final String id;
  final String title;
  final DateTime targetDate;

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? targetDate,
  }) {
    return CountdownEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'targetDate': targetDate.toIso8601String(),
      };

  factory CountdownEvent.fromJson(Map<String, dynamic> json) {
    return CountdownEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
    );
  }

  static String encodeList(List<CountdownEvent> events) {
    return jsonEncode(events.map((e) => e.toJson()).toList());
  }

  static List<CountdownEvent> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final data = jsonDecode(raw);
      if (data is! List) return const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(CountdownEvent.fromJson)
          .toList(growable: false);
    } on FormatException {
      return const [];
    }
  }
}
