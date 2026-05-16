class MissMeMessage {
  const MissMeMessage({
    required this.id,
    required this.title,
    required this.messages,
    this.audio,
  });

  final int id;
  final String title;
  final List<String> messages;
  final String? audio;

  factory MissMeMessage.fromJson(Map<String, dynamic> json) {
    final messagesRaw = json['messages'];
    final List<String> messages;
    if (messagesRaw is List) {
      messages = messagesRaw
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
    } else if (json['message'] is String) {
      messages = <String>[json['message'] as String];
    } else {
      messages = const <String>[];
    }

    return MissMeMessage(
      id: json['id'] as int,
      title: json['title'] as String,
      messages: messages,
      audio: json['audio'] as String?,
    );
  }
}
