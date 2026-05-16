import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/miss_me_message.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';
import 'widgets/miss_me_card.dart';

class MissMeScreen extends StatefulWidget {
  const MissMeScreen({super.key});

  @override
  State<MissMeScreen> createState() => _MissMeScreenState();
}

class _MissMeScreenState extends State<MissMeScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final Future<List<MissMeMessage>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.loadMissMeMessages();
  }

  void _showAudioNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Sesli mesaj sonraki güncellemede'),
        ),
      );
  }

  void _openMessage(MissMeMessage message) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MessageSheet(category: message),
    );
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
                title: 'Beni Özlediğinde',
                subtitle: 'Buraya gel, okumak için bir sebep var.',
              ),
              Expanded(
                child: FutureBuilder<List<MissMeMessage>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Mesajlar yüklenemedi.',
                          style: AppTextStyles.bodyMuted,
                        ),
                      );
                    }
                    final messages = snapshot.data ?? const [];
                    if (messages.isEmpty) {
                      return Center(
                        child: Text(
                          'Henüz mesaj eklenmedi.',
                          style: AppTextStyles.bodyMuted,
                        ),
                      );
                    }
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(24, 8, 24, 32),
                          itemCount: messages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return MissMeCard(
                              message: message,
                              onTap: () => _openMessage(message),
                              onAudioTap: _showAudioNotice,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageSheet extends StatefulWidget {
  const _MessageSheet({required this.category});

  final MissMeMessage category;

  @override
  State<_MessageSheet> createState() => _MessageSheetState();
}

class _MessageSheetState extends State<_MessageSheet> {
  final Random _random = Random();
  late String _current;
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
    _current = _pick();
  }

  String _pick() {
    final list = widget.category.messages;
    if (list.isEmpty) return '';
    if (list.length == 1) {
      _lastIndex = 0;
      return list.first;
    }
    int idx;
    do {
      idx = _random.nextInt(list.length);
    } while (idx == _lastIndex);
    _lastIndex = idx;
    return list[idx];
  }

  void _shuffle() {
    setState(() {
      _current = _pick();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasMessage = _current.isNotEmpty;
    final hasMultiple = widget.category.messages.length > 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: AnimatedFadeSlide(
              duration: const Duration(milliseconds: 500),
              child: SoftCard(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.category.title,
                            style: AppTextStyles.headlineMedium
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: AppColors.mutedText,
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: 'Kapat',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        hasMessage
                            ? _current
                            : 'Bu kategoride henüz mesaj yok.',
                        key: ValueKey('miss-$_current'),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 17,
                          height: 1.6,
                        ),
                      ),
                    ),
                    if (hasMultiple) ...[
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _shuffle,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Başka bir mesaj'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
