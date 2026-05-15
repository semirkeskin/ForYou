import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/models/app_config.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  static const LocalJsonService _service = LocalJsonService();

  AppConfig? _config;
  String? _error;
  Timer? _ticker;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final config = await _service.loadAppConfig();
      if (!mounted) return;
      setState(() {
        _config = config;
        _remaining = AppDateUtils.remaining(config.targetDate);
      });
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _remaining = AppDateUtils.remaining(config.targetDate);
        });
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Geri sayım yüklenemedi.');
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Geri Sayım'),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(_error!, style: AppTextStyles.bodyMuted),
        ),
      );
    }
    final config = _config;
    if (config == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final isPast = _remaining.isNegative || _remaining == Duration.zero;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: AnimatedFadeSlide(
            child: SoftCard(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 36,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    config.countdownTitle,
                    style: AppTextStyles.bodyMuted.copyWith(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (isPast)
                    Text(
                      'Bugün o özel gün 💛',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 32,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    _CountdownNumbers(remaining: _remaining),
                  const SizedBox(height: 20),
                  Text(
                    _formatTargetDate(config.targetDate),
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTargetDate(DateTime date) {
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)} '
        '${pad(date.hour)}:${pad(date.minute)}';
  }
}

class _CountdownNumbers extends StatelessWidget {
  const _CountdownNumbers({required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24);
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Unit(value: days, label: 'gün'),
        _Unit(value: hours, label: 'saat'),
        _Unit(value: minutes, label: 'dakika'),
        _Unit(value: seconds, label: 'saniye'),
      ],
    );
  }
}

class _Unit extends StatelessWidget {
  const _Unit({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 44,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodyMuted),
      ],
    );
  }
}
