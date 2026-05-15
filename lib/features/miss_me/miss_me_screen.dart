import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/miss_me_message.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
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
      builder: (context) => _MessageSheet(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
    );
  }
}

class _MessageSheet extends StatelessWidget {
  const _MessageSheet({required this.message});

  final MissMeMessage message;

  @override
  Widget build(BuildContext context) {
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
                            message.title,
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
                    Text(
                      message.message,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 17,
                        height: 1.6,
                      ),
                    ),
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
