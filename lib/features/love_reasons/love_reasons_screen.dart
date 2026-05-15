import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/love_reason.dart';
import '../../data/services/local_json_service.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/primary_button.dart';
import 'widgets/love_reason_card.dart';

class LoveReasonsScreen extends StatefulWidget {
  const LoveReasonsScreen({super.key, required this.preferences});

  final PreferencesService preferences;

  @override
  State<LoveReasonsScreen> createState() => _LoveReasonsScreenState();
}

class _LoveReasonsScreenState extends State<LoveReasonsScreen> {
  static const LocalJsonService _service = LocalJsonService();
  final Random _random = Random();

  List<LoveReason>? _reasons;
  LoveReason? _current;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final reasons = await _service.loadLoveReasons();
      if (!mounted) return;
      setState(() {
        _reasons = reasons;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Sevgi sebepleri yüklenemedi.';
        _loading = false;
      });
    }
  }

  void _pickNewReason() {
    final reasons = _reasons;
    if (reasons == null || reasons.isEmpty) return;

    final recent = widget.preferences.recentLoveReasonIds;

    Iterable<LoveReason> candidates;
    if (reasons.length <= 3) {
      // Liste 3'ten az ise sadece son gosterileni haric tut.
      final lastId = recent.isNotEmpty ? recent.last : null;
      candidates = reasons.where((r) => r.id != lastId);
    } else {
      candidates = reasons.where((r) => !recent.contains(r.id));
    }

    final pool = candidates.toList();
    if (pool.isEmpty) {
      // Edge case: tum sebepler son pencerede. En eski ID'yi unutup tekrar dene.
      pool.addAll(reasons);
    }

    final picked = pool[_random.nextInt(pool.length)];
    setState(() => _current = picked);
    widget.preferences.pushRecentLoveReason(picked.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CherryBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              const PageHeader(
                title: 'Seni Sevme Sebeplerim',
                subtitle: 'Bir buton, bir sebep.',
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(_error!, style: AppTextStyles.bodyMuted),
        ),
      );
    }
    final reasons = _reasons ?? const [];
    if (reasons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Henüz sebep eklenmedi.',
            style: AppTextStyles.bodyMuted,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    switchInCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.96, end: 1)
                              .animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _current == null
                        ? const _PlaceholderCard(key: ValueKey('placeholder'))
                        : LoveReasonCard(
                            key: ValueKey('reason-${_current!.id}'),
                            text: _current!.text,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _current == null ? 'Bir sebep aç' : 'Yeni bir sebep aç',
                onPressed: _pickNewReason,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            color: AppColors.accent,
            size: 60,
          ),
          const SizedBox(height: 20),
          Text(
            'Butona basınca seni neden sevdiğimi söyleyeceğim.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
