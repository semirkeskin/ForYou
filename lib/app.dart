import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/models/app_config.dart';
import 'data/services/preferences_service.dart';
import 'features/home/home_screen.dart';
import 'features/intro/intro_screen.dart';

class SanaSakladiklarimApp extends StatelessWidget {
  const SanaSakladiklarimApp({
    super.key,
    required this.preferences,
    required this.config,
  });

  final PreferencesService preferences;
  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(maxScaleFactor: 1.3),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: preferences.introSeen
          ? HomeScreen(preferences: preferences, config: config)
          : IntroScreen(preferences: preferences, config: config),
    );
  }
}
