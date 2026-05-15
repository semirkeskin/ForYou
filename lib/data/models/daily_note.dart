class DailyNote {
  const DailyNote({required this.id, required this.text});

  final int id;
  final String text;

  factory DailyNote.fromJson(Map<String, dynamic> json) {
    return DailyNote(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}
