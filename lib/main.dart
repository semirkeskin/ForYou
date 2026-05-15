import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/models/app_config.dart';
import 'data/services/local_json_service.dart';
import 'data/services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final preferences = await PreferencesService.create();
  final AppConfig config = await _loadConfigSafely();

  runApp(SanaSakladiklarimApp(
    preferences: preferences,
    config: config,
  ));
}

Future<AppConfig> _loadConfigSafely() async {
  try {
    return await const LocalJsonService().loadAppConfig();
  } catch (_) {
    return AppConfig(
      appName: 'Sana Sakladıklarım',
      greetingName: 'Sevgilim',
      countdownTitle: 'Bir sonraki buluşmamıza',
      targetDate: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
