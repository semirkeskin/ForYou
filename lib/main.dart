import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  final preferences = await PreferencesService.create();
  runApp(SanaSakladiklarimApp(preferences: preferences));
}
