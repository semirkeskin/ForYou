class MissMeMessage {
  const MissMeMessage({
    required this.id,
    required this.title,
    required this.message,
    this.audio,
  });

  final int id;
  final String title;
  final String message;
  final String? audio;

  factory MissMeMessage.fromJson(Map<String, dynamic> json) {
    return MissMeMessage(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      audio: json['audio'] as String?,
    );
  }
}
