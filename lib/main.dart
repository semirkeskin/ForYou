import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/models/app_config.dart';
import 'data/models/love_ping.dart';
import 'data/models/special_hour_message.dart';
import 'data/services/local_json_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final preferences = await PreferencesService.create();
  const service = LocalJsonService();
  final AppConfig config = await _loadConfigSafely(service);
  final SpecialHourMessage specialHour =
      await _loadSpecialHourSafely(service);
  final List<LovePing> lovePings = await _loadLovePingsSafely(service);

  // Bildirim altyapisi: special hours (10:10, 11:11, ...) + love pings (gunluk
  // belli saatlerde "seni ozledim/sevdim" mesajlari)
  await NotificationService.init();
  await NotificationService.scheduleAll(
    specialHour: specialHour,
    lovePings: lovePings,
  );

  runApp(SanaSakladiklarimApp(
    preferences: preferences,
    config: config,
    specialHour: specialHour,
  ));
}

Future<AppConfig> _loadConfigSafely(LocalJsonService service) async {
  try {
    return await service.loadAppConfig();
  } on Exception {
    return const AppConfig(
      appName: 'Kiraz',
      greetingName: 'Sevgilim',
    );
  }
}

Future<SpecialHourMessage> _loadSpecialHourSafely(
    LocalJsonService service) async {
  try {
    return await service.loadSpecialHourMessage();
  } on Exception {
    return SpecialHourMessage.empty;
  }
}

Future<List<LovePing>> _loadLovePingsSafely(
    LocalJsonService service) async {
  try {
    return await service.loadLovePings();
  } on Exception {
    return const [];
  }
}
