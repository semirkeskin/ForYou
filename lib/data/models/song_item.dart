class SongItem {
  const SongItem({
    required this.id,
    required this.title,
    required this.artist,
    this.reason,
    this.link,
  });

  final int id;
  final String title;
  final String artist;
  final String? reason;
  final String? link;

  factory SongItem.fromJson(Map<String, dynamic> json) {
    return SongItem(
      id: json['id'] as int,
      title: json['title'] as String,
      artist: json['artist'] as String,
      reason: _readOptional(json['reason']),
      link: _readOptional(json['link']),
    );
  }

  static String? _readOptional(dynamic value) {
    if (value == null) return null;
    final str = value as String;
    return str.isEmpty ? null : str;
  }
}
