import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surprise_box.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class SurpriseBoxDetailScreen extends StatefulWidget {
  const SurpriseBoxDetailScreen({super.key, required this.box});

  final SurpriseBox box;

  @override
  State<SurpriseBoxDetailScreen> createState() =>
      _SurpriseBoxDetailScreenState();
}

class _SurpriseBoxDetailScreenState extends State<SurpriseBoxDetailScreen> {
  final Random _random = Random();
  late String _current;
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
    _current = _pick();
  }

  String _pick() {
    final messages = widget.box.messages;
    if (messages.isEmpty) return '';
    if (messages.length == 1) {
      _lastIndex = 0;
      return messages.first;
    }
    int idx;
    do {
      idx = _random.nextInt(messages.length);
    } while (idx == _lastIndex);
    _lastIndex = idx;
    return messages[idx];
  }

  void _shuffle() {
    setState(() {
      _current = _pick();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasMessage = _current.isNotEmpty;
    final hasMultiple = widget.box.messages.length > 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CherryBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              PageHeader(
                title: widget.box.title,
                subtitle: widget.box.subtitle,
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOut,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.97, end: 1)
                                  .animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: AnimatedFadeSlide(
                          key: ValueKey('surprise-$_current'),
                          duration: const Duration(milliseconds: 450),
                          child: SoftCard(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  hasMessage
                                      ? _current
                                      : 'Bu kutuda henüz mesaj yok.',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontSize: 19,
                                    height: 1.65,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (hasMultiple)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: OutlinedButton.icon(
                    onPressed: _shuffle,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Başka bir mesaj'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
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
