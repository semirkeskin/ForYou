class AppConfig {
  const AppConfig({
    required this.appName,
    required this.greetingName,
    this.secretWord,
    this.secretMeaning,
  });

  final String appName;
  final String greetingName;
  final String? secretWord;
  final String? secretMeaning;

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['appName'] as String? ?? 'Sana Sakladıklarım',
      greetingName: json['greetingName'] as String? ?? 'Sevgilim',
      secretWord: json['secretWord'] as String?,
      secretMeaning: json['secretMeaning'] as String?,
    );
  }
}
