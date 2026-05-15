class AppConfig {
  const AppConfig({
    required this.appName,
    required this.greetingName,
    required this.countdownTitle,
    required this.targetDate,
    this.secretWord,
    this.secretMeaning,
  });

  final String appName;
  final String greetingName;
  final String countdownTitle;
  final DateTime targetDate;
  final String? secretWord;
  final String? secretMeaning;

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['appName'] as String? ?? 'Sana Sakladıklarım',
      greetingName: json['greetingName'] as String? ?? 'Sevgilim',
      countdownTitle:
          json['countdownTitle'] as String? ?? 'Bir sonraki buluşmamıza',
      targetDate: DateTime.parse(json['targetDate'] as String),
      secretWord: json['secretWord'] as String?,
      secretMeaning: json['secretMeaning'] as String?,
    );
  }
}
