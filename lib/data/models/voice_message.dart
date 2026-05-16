class VoiceMessage {
  const VoiceMessage({
    required this.id,
    required this.title,
    required this.audioPath,
    this.subtitle,
  });

  final int id;
  final String title;

  /// assets/audio/xxx.mp3 gibi local asset yolu.
  final String audioPath;

  final String? subtitle;

  factory VoiceMessage.fromJson(Map<String, dynamic> json) {
    final raw = json['subtitle'];
    return VoiceMessage(
      id: json['id'] as int,
      title: json['title'] as String,
      audioPath: json['audioPath'] as String,
      subtitle: raw is String && raw.isNotEmpty ? raw : null,
    );
  }
}
