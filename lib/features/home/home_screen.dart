import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/app_config.dart';
import '../../data/models/daily_note.dart';
import '../../data/models/memory_item.dart';
import '../../data/services/local_json_service.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/soft_card.dart';
import '../countdown/countdown_screen.dart';
import '../love_reasons/love_reasons_screen.dart';
import '../memories/memories_screen.dart';
import '../settings/settings_screen.dart';
import '../songs/songs_screen.dart';
import '../surprise_boxes/surprise_boxes_screen.dart';
import '../voice_messages/voice_messages_screen.dart';

const List<String> _kRotatingGreetings = [
  'Bugün seni bisssürüüüü össledimmm 🍒',
  'Seni çoook amaaa çoookkk seviyorumm 🥺',
  'Bugün yine yeniden aşık oluyorum sana 🤍',
  'Güzelimm ✨',
];

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
  DateTime? _relationshipStart;
  late Future<List<MemoryItem>> _memoriesFuture;
  late Future<List<DailyNote>> _dailyNotesFuture;

  @override
  void initState() {
    super.initState();
    _customBackgroundPath = widget.preferences.customBackgroundPath;
    _relationshipStart = widget.preferences.relationshipStartDate;
    _memoriesFuture = _service.loadMemories();
    _dailyNotesFuture = _service.loadDailyNotes();
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
      _relationshipStart = widget.preferences.relationshipStartDate;
    });
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => screen),
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

  String _todaysGreeting() {
    final idx = AppDateUtils.dailyIndex(_kRotatingGreetings.length);
    return _kRotatingGreetings[idx];
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.horizontalPadding(context);
    final maxW = Responsive.contentMaxWidth(context);
    final textScale = Responsive.textScale(context);

    final cards = <_HomeCardData>[
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
        title: 'Şarkılarımız',
        icon: Icons.music_note_outlined,
        onTap: () => _open(context, const SongsScreen()),
      ),
      _HomeCardData(
        title: 'Sesli Mesajlar',
        icon: Icons.mic_none_outlined,
        onTap: () => _open(context, const VoiceMessagesScreen()),
      ),
      _HomeCardData(
        title: 'Geri Sayım',
        icon: Icons.timer_outlined,
        onTap: () => _open(
          context,
          CountdownScreen(preferences: widget.preferences),
        ),
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hPad, 24, hPad - 8, 8),
                        child: AnimatedFadeSlide(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hoş geldin ${widget.config.greetingName} 🌙',
                                      style: AppTextStyles.headlineLarge
                                          .copyWith(
                                        fontSize: 28 * textScale,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 8 : 6),
                                    GestureDetector(
                                      onTap: () => _whisperSecret(context),
                                      child: Text(
                                        _todaysGreeting(),
                                        style: AppTextStyles.bodyMuted
                                            .copyWith(
                                          fontSize: 14 * textScale,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Semantics(
                                label: 'Ayarlar',
                                button: true,
                                child: IconButton(
                                  iconSize: isTablet ? 28 : 24,
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
                        padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 8),
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
                              return _TodaysMemoryHero(memory: memory);
                            },
                          ),
                        ),
                      ),
                    ),
                    if (_relationshipStart != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 0),
                          child: AnimatedFadeSlide(
                            delay: const Duration(milliseconds: 140),
                            child: _RelationshipBanner(
                              startDate: _relationshipStart!,
                              textScale: textScale,
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 0),
                        child: AnimatedFadeSlide(
                          delay: const Duration(milliseconds: 180),
                          child: FutureBuilder<List<DailyNote>>(
                            future: _dailyNotesFuture,
                            builder: (context, snapshot) {
                              final notes = snapshot.data;
                              if (notes == null || notes.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final i =
                                  AppDateUtils.dailyIndex(notes.length);
                              return _TodaysNoteInline(
                                note: notes[i],
                                textScale: textScale,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(hPad, 18, hPad, hPad),
                      sliver: SliverGrid(
                        gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: isTablet ? 260 : 220,
                          mainAxisSpacing: isTablet ? 16 : 14,
                          crossAxisSpacing: isTablet ? 16 : 14,
                          childAspectRatio: 1.25,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final data = cards[index];
                            return AnimatedFadeSlide(
                              delay: Duration(milliseconds: 100 * index),
                              child: SoftCard(
                                onTap: data.onTap,
                                padding: EdgeInsets.fromLTRB(
                                  isTablet ? 20 : 16,
                                  isTablet ? 18 : 14,
                                  isTablet ? 20 : 16,
                                  isTablet ? 18 : 16,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      data.icon,
                                      size: isTablet ? 30 : 26,
                                      color: AppColors.primary,
                                    ),
                                    Text(
                                      data.title,
                                      style: AppTextStyles.titleMedium
                                          .copyWith(
                                        fontSize: 15.5 * textScale,
                                        fontWeight: FontWeight.w600,
                                      ),
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

/// Hero kart — landscape/portrait responsive + blur backdrop.
/// Foto BoxFit.contain ile tam gosterilir; arka planda ayni fotonun blur'lu
/// cover versiyonu zemin olur. Boylece dikey fotolar kirpilmaz.
class _TodaysMemoryHero extends StatelessWidget {
  const _TodaysMemoryHero({required this.memory});

  final MemoryItem memory;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isLandscape = Responsive.isLandscape(context);
    // Portrait: 3:2 (dikey fotolarda daha az bos alan, daha az kirpilma)
    // Tablet landscape: 16:9 (yatayda dengeli)
    final aspect = isLandscape && isTablet ? 16 / 9 : 3 / 2;
    final maxH = isTablet ? 420.0 : 320.0;
    final image = AssetImage(memory.image);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: AspectRatio(
        aspectRatio: aspect,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1) Arka plan: ayni foto blur'lu cover (boslugu doldurur).
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Image(
                  image: image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: AppColors.accent.withOpacity(0.4),
                  ),
                ),
              ),
              // Blur uzerine hafif krem tonlama (canlilik kirpilmasin).
              Container(
                color: AppColors.background.withOpacity(0.18),
              ),
              // 2) On plan: foto contain — tum foto gorunur, kirpilmaz.
              Center(
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
              // 3) Altta gradient: kapsulun arkasi daha okunabilir olsun.
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0x80000000),
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
              // 4) "Bugunun Anisi" kapsulu.
              Positioned(
                left: 18,
                bottom: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelationshipBanner extends StatelessWidget {
  const _RelationshipBanner({
    required this.startDate,
    required this.textScale,
  });

  final DateTime startDate;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final days = DateTime.now().difference(startDate).inDays;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.primary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sevgilim oldun-dan bu yana',
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 12 * textScale,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$days gün 🤍',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontSize: 18 * textScale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bugunun Notu — ana sayfada inline blok.
class _TodaysNoteInline extends StatelessWidget {
  const _TodaysNoteInline({required this.note, required this.textScale});

  final DailyNote note;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.45),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.wb_sunny_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Bugünün Notu',
                style: AppTextStyles.bodyMuted.copyWith(
                  color: AppColors.primary,
                  fontSize: 12 * textScale,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            note.text,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 15.5 * textScale,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
