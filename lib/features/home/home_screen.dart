import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/models/app_config.dart';
import '../../data/models/memory_item.dart';
import '../../data/services/local_json_service.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/soft_card.dart';
import '../countdown/countdown_screen.dart';
import '../daily_note/daily_note_screen.dart';
import '../love_reasons/love_reasons_screen.dart';
import '../memories/memories_screen.dart';
import '../memories/memory_detail_screen.dart';
import '../miss_me/miss_me_screen.dart';
import '../settings/settings_screen.dart';
import '../surprise_boxes/surprise_boxes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.preferences,
    required this.config,
  });

  final PreferencesService preferences;
  final AppConfig config;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LocalJsonService _service = LocalJsonService();

  String? _customBackgroundPath;
  late Future<List<MemoryItem>> _memoriesFuture;

  @override
  void initState() {
    super.initState();
    _customBackgroundPath = widget.preferences.customBackgroundPath;
    _memoriesFuture = _service.loadMemories();
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(preferences: widget.preferences),
      ),
    );
    if (!mounted) return;
    setState(() {
      _customBackgroundPath = widget.preferences.customBackgroundPath;
    });
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _openTodaysMemory(List<MemoryItem> memories, int index) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => MemoryDetailScreen(
          memories: memories,
          initialIndex: index,
        ),
      ),
    );
  }

  void _whisperSecret(BuildContext context) {
    final word = widget.config.secretWord;
    final meaning = widget.config.secretMeaning;
    if (word == null || meaning == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$word 🍒  ($meaning)'),
          duration: const Duration(seconds: 3),
        ),
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
          LoveReasonsScreen(preferences: widget.preferences),
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
      body: Stack(
        children: [
          Positioned.fill(child: _buildBackground()),
          if (_customBackgroundPath != null)
            Positioned.fill(
              child: Container(
                color: AppColors.background.withOpacity(0.45),
              ),
            ),
          SafeArea(
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
                                  'Hoş geldin ${widget.config.greetingName} 🌙',
                                  style: AppTextStyles.headlineLarge,
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () => _whisperSecret(context),
                                  child: Text(
                                    'Bugün de seni düşündüm. 🍒',
                                    style: AppTextStyles.bodyMuted,
                                  ),
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
                              onPressed: _openSettings,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: AnimatedFadeSlide(
                      delay: const Duration(milliseconds: 100),
                      child: FutureBuilder<List<MemoryItem>>(
                        future: _memoriesFuture,
                        builder: (context, snapshot) {
                          final memories = snapshot.data;
                          if (memories == null || memories.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final index =
                              AppDateUtils.dailyIndex(memories.length);
                          final memory = memories[index];
                          return _TodaysMemoryHero(
                            memory: memory,
                            onTap: () => _openTodaysMemory(memories, index),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                Icon(
                                  data.icon,
                                  size: 32,
                                  color: AppColors.primary,
                                ),
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
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final path = _customBackgroundPath;
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => _defaultPattern(),
        );
      }
    }
    return _defaultPattern();
  }

  Widget _defaultPattern() {
    return const CherryBackdrop(child: SizedBox.expand());
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

class _TodaysMemoryHero extends StatelessWidget {
  const _TodaysMemoryHero({required this.memory, required this.onTap});

  final MemoryItem memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 280,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                memory.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: AppColors.accent.withOpacity(0.4),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                    stops: [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Bugünün Anısı',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _heroCaption(memory),
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _heroCaption(MemoryItem memory) {
    if (memory.title != null && memory.title!.isNotEmpty) {
      return memory.title!;
    }
    if (memory.description != null && memory.description!.isNotEmpty) {
      return memory.description!;
    }
    return 'Bu günü hatırlıyor musun?';
  }
}
