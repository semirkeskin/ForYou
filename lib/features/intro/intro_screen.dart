import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/app_config.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/primary_button.dart';
import '../home/home_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
    required this.preferences,
    required this.config,
  });

  final PreferencesService preferences;
  final AppConfig config;

  Future<void> _onStart(BuildContext context) async {
    await preferences.setIntroSeen(true);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(preferences: preferences, config: config),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedFadeSlide(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Bu uygulama internette yok.\nPlay Store\'da yok.\nBaşka kimsede yok.',
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedFadeSlide(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'Çünkü sadece ${config.greetingName} için yapıldı.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.mutedText,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 56),
                  AnimatedFadeSlide(
                    delay: const Duration(milliseconds: 900),
                    child: PrimaryButton(
                      label: 'Başla',
                      onPressed: () => _onStart(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
