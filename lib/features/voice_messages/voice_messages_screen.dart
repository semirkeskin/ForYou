import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/voice_message.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class VoiceMessagesScreen extends StatefulWidget {
  const VoiceMessagesScreen({super.key});

  @override
  State<VoiceMessagesScreen> createState() => _VoiceMessagesScreenState();
}

class _VoiceMessagesScreenState extends State<VoiceMessagesScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final Future<List<VoiceMessage>> _future;
  final AudioPlayer _player = AudioPlayer();
  int? _playingId;

  @override
  void initState() {
    super.initState();
    _future = _service.loadVoiceMessages();
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.processingState == ProcessingState.completed) {
        setState(() => _playingId = null);
        _player.stop();
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle(VoiceMessage msg) async {
    if (_playingId == msg.id && _player.playing) {
      await _player.pause();
      if (!mounted) return;
      setState(() {});
      return;
    }
    try {
      await _player.stop();
      await _player.setAsset(msg.audioPath);
      if (!mounted) return;
      setState(() => _playingId = msg.id);
      await _player.play();
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _playingId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ses dosyası çalınamadı: $e')),
      );
    }
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
                title: 'Sesli Mesajlar',
                subtitle: 'Sesimi özlediğinde dinle.',
              ),
              Expanded(
                child: FutureBuilder<List<VoiceMessage>>(
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
                      return _empty('Sesli mesajlar yüklenemedi.');
                    }
                    final messages = snapshot.data ?? const [];
                    if (messages.isEmpty) {
                      return _empty(
                        'Henüz sesli mesaj eklenmedi.\n'
                        'assets/audio/ klasörüne mp3 koyup\n'
                        'voice_messages.json dosyasına ekle.',
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
                            final msg = messages[index];
                            final isPlaying =
                                _playingId == msg.id && _player.playing;
                            return AnimatedFadeSlide(
                              delay: Duration(milliseconds: 70 * index),
                              child: _VoiceTile(
                                message: msg,
                                isPlaying: isPlaying,
                                onTap: () => _toggle(msg),
                              ),
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

  Widget _empty(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mic_none_outlined,
              size: 56,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceTile extends StatelessWidget {
  const _VoiceTile({
    required this.message,
    required this.isPlaying,
    required this.onTap,
  });

  final VoiceMessage message;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isPlaying ? AppColors.primary : AppColors.accent,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(
              isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.title,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (message.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    message.subtitle!,
                    style: AppTextStyles.bodyMuted,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
