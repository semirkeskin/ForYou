import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/soft_card.dart';
import '../countdown/countdown_screen.dart';
import '../daily_note/daily_note_screen.dart';
import '../love_reasons/love_reasons_screen.dart';
import '../memories/memories_screen.dart';
import '../miss_me/miss_me_screen.dart';
import '../settings/settings_screen.dart';
import '../surprise_boxes/surprise_boxes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.preferences});

  final PreferencesService preferences;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = <_HomeCardData>[
      _HomeCardData(
        title: 'Bugünün Notu',
        icon: Icons.wb_sunny_outlined,
        onTap: () => _open(context, const DailyNoteScreen()),
      ),
      _HomeCardData(
        title: 'Seni Sevme Sebeplerim',
        icon: Icons.favorite_outline,
        onTap: () => _open(
          context,
          LoveReasonsScreen(preferences: preferences),
        ),
      ),
      _HomeCardData(
        title: 'Anılarımız',
        icon: Icons.photo_library_outlined,
        onTap: () => _open(context, const MemoriesScreen()),
      ),
      _HomeCardData(
        title: 'Sürpriz Kutuları',
        icon: Icons.card_giftcard_outlined,
        onTap: () => _open(context, const SurpriseBoxesScreen()),
      ),
      _HomeCardData(
        title: 'Beni Özlediğinde',
        icon: Icons.mail_outline,
        onTap: () => _open(context, const MissMeScreen()),
      ),
      _HomeCardData(
        title: 'Geri Sayım',
        icon: Icons.timer_outlined,
        onTap: () => _open(context, const CountdownScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
                child: AnimatedFadeSlide(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hoş geldin sevgilim 🌙',
                              style: AppTextStyles.headlineLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Bugün de seni düşündüm.',
                              style: AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                      ),
                      Semantics(
                        label: 'Ayarlar',
                        button: true,
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          color: AppColors.mutedText,
                          tooltip: 'Ayarlar',
                          onPressed: () => _open(
                            context,
                            SettingsScreen(preferences: preferences),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 280,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final data = cards[index];
                    return AnimatedFadeSlide(
                      delay: Duration(milliseconds: 120 * index),
                      child: SoftCard(
                        onTap: data.onTap,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(data.icon, size: 32, color: AppColors.primary),
                            Text(
                              data.title,
                              style: AppTextStyles.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: cards.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCardData {
  const _HomeCardData({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
}
