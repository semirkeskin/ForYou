class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.image,
    this.title,
    this.date,
    this.description,
  });

  final int id;
  final String image;
  final String? title;
  final String? date;
  final String? description;

  /// En az bir metin alani var mi — UI tarafında glass card gösterimi için.
  bool get hasAnyText =>
      (title != null && title!.isNotEmpty) ||
      (date != null && date!.isNotEmpty) ||
      (description != null && description!.isNotEmpty);

  factory MemoryItem.fromJson(Map<String, dynamic> json) {
    return MemoryItem(
      id: json['id'] as int,
      image: json['image'] as String,
      title: _readOptionalString(json['title']),
      date: _readOptionalString(json['date']),
      description: _readOptionalString(json['description']),
    );
  }

  static String? _readOptionalString(dynamic value) {
    if (value == null) return null;
    final str = value as String;
    return str.isEmpty ? null : str;
  }
}
