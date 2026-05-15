class SurpriseBox {
  const SurpriseBox({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.requiresConfirmation,
  });

  final int id;
  final String title;
  final String subtitle;
  final String message;
  final bool requiresConfirmation;

  factory SurpriseBox.fromJson(Map<String, dynamic> json) {
    return SurpriseBox(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      message: json['message'] as String,
      requiresConfirmation: json['requiresConfirmation'] as bool? ?? false,
    );
  }
}
