import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/responsive.dart';
import 'data/models/app_config.dart';
import 'data/models/special_hour_message.dart';
import 'data/services/preferences_service.dart';
import 'features/_shared/special_hour_listener.dart';
import 'features/home/home_screen.dart';
import 'features/intro/intro_screen.dart';

class SanaSakladiklarimApp extends StatelessWidget {
  const SanaSakladiklarimApp({
    super.key,
    required this.preferences,
    required this.config,
    required this.specialHour,
  });

  final PreferencesService preferences;
  final AppConfig config;
  final SpecialHourMessage specialHour;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        // Tabletlerde tipografiyi otomatik 1.1x scale et, sistem ayari
        // 1.3x ile kapsa. Boylece tum detay ekranlari elle dokunulmadan
        // tablette okunabilir kalir.
        final boost = Responsive.isTablet(context) ? 1.1 : 1.0;
        final scaler = TextScaler.linear(
          (mq.textScaler.scale(1) * boost).clamp(0.85, 1.3),
        );
        return MediaQuery(
          data: mq.copyWith(textScaler: scaler),
          child: SpecialHourListener(
            message: specialHour,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: preferences.introSeen
          ? HomeScreen(preferences: preferences, config: config)
          : IntroScreen(preferences: preferences, config: config),
    );
  }
}
