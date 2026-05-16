class SurpriseBox {
  const SurpriseBox({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.messages,
    required this.requiresConfirmation,
  });

  final int id;
  final String title;
  final String subtitle;
  final List<String> messages;
  final bool requiresConfirmation;

  factory SurpriseBox.fromJson(Map<String, dynamic> json) {
    final messagesRaw = json['messages'];
    final List<String> messages;
    if (messagesRaw is List) {
      messages = messagesRaw
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
    } else if (json['message'] is String) {
      // Eski tek-mesajli formatla geri uyum
      messages = <String>[json['message'] as String];
    } else {
      messages = const <String>[];
    }

    return SurpriseBox(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      messages: messages,
      requiresConfirmation: json['requiresConfirmation'] as bool? ?? false,
    );
  }
}
