class LoveReason {
  const LoveReason({required this.id, required this.text});

  final int id;
  final String text;

  factory LoveReason.fromJson(Map<String, dynamic> json) {
    return LoveReason(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}
