class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.image,
  });

  final int id;
  final String title;
  final String date;
  final String description;
  final String image;

  factory MemoryItem.fromJson(Map<String, dynamic> json) {
    return MemoryItem(
      id: json['id'] as int,
      title: json['title'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }
}
