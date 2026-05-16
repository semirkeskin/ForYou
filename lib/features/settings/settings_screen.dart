import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/app_config.dart';
import '../../data/services/background_service.dart';
import '../../data/services/local_json_service.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';
import '../intro/intro_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.preferences});

  final PreferencesService preferences;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final BackgroundService _backgroundService =
      BackgroundService(widget.preferences);

  AppConfig? _config;
  String _version = '—';
  String? _customBackgroundPath;
  DateTime? _relationshipStart;
  bool _pickingBackground = false;

  @override
  void initState() {
    super.initState();
    _customBackgroundPath = widget.preferences.customBackgroundPath;
    _relationshipStart = widget.preferences.relationshipStartDate;
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await _service.loadAppConfig();
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _config = config;
        _version = info.version.isEmpty ? '1.0.0' : info.version;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> _resetIntro() async {
    await widget.preferences.setIntroSeen(false);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Tanıtım ekranı sıfırlandı')),
      );
    if (_config == null) return;
    await Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute(
        builder: (_) => IntroScreen(
          preferences: widget.preferences,
          config: _config!,
        ),
      ),
      (_) => false,
    );
  }

  Future<void> _pickBackground() async {
    if (_pickingBackground) return;
    setState(() => _pickingBackground = true);
    try {
      final path = await _backgroundService.pickAndSetBackground();
      if (!mounted) return;
      if (path != null) {
        setState(() => _customBackgroundPath = path);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Arka plan güncellendi')),
          );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Resim seçilemedi: $e')),
        );
    } finally {
      if (mounted) setState(() => _pickingBackground = false);
    }
  }

  Future<void> _resetBackground() async {
    await _backgroundService.clearBackground();
    if (!mounted) return;
    setState(() => _customBackgroundPath = null);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Varsayılan arka plan')),
      );
  }

  Future<void> _pickRelationshipDate() async {
    final initial = _relationshipStart ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: 'İlişki başlangıç tarihi',
    );
    if (picked == null || !mounted) return;
    await widget.preferences.setRelationshipStartDate(picked);
    if (!mounted) return;
    setState(() => _relationshipStart = picked);
  }

  Future<void> _clearRelationshipDate() async {
    await widget.preferences.setRelationshipStartDate(null);
    if (!mounted) return;
    setState(() => _relationshipStart = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CherryBackdrop(
        child: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Ayarlar'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBackgroundCard(),
                        const SizedBox(height: 14),
                        _buildRelationshipCard(),
                        const SizedBox(height: 14),
                        SoftCard(
                          onTap: _resetIntro,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.restart_alt_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tanıtım ekranını tekrar göster',
                                  style: AppTextStyles.titleMedium,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.mutedText,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SoftCard(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.mutedText,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Versiyon $_version',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            'Sana özel hazırlandı 🤍',
                            style: AppTextStyles.bodyMuted.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildBackgroundCard() {
    final hasCustom = _customBackgroundPath != null;
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.wallpaper_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ana sayfa arka planı',
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasCustom
                ? 'Şu an telefonundan seçtiğin bir resim kullanılıyor.'
                : 'Varsayılan kiraz dokusu kullanılıyor.',
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickingBackground ? null : _pickBackground,
                  icon: _pickingBackground
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.photo_library_outlined),
                  label: Text(hasCustom ? 'Değiştir' : 'Resim seç'),
                ),
              ),
              if (hasCustom) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickingBackground ? null : _resetBackground,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Varsayılana dön'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mutedText,
                      side: BorderSide(
                        color: AppColors.mutedText.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipCard() {
    final start = _relationshipStart;
    final hasDate = start != null;
    final daysSince =
        hasDate ? DateTime.now().difference(start).inDays : null;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_outline, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'İlişki başlangıcımız',
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasDate
                ? '${_formatRelationshipDate(start)} — bu yana $daysSince gün 🤍'
                : 'Tarihimizi belirle, ana sayfada günleri sayalım.',
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickRelationshipDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(hasDate ? 'Tarihi değiştir' : 'Tarih seç'),
                ),
              ),
              if (hasDate) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearRelationshipDate,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Sıfırla'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mutedText,
                      side: BorderSide(
                        color: AppColors.mutedText.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatRelationshipDate(DateTime d) {
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${pad(d.month)}-${pad(d.day)}';
  }
}
