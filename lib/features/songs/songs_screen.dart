import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/song_item.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final Future<List<SongItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.loadSongs();
  }

  Future<void> _openLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bağlantı açılamadı')),
      );
    }
  }

  void _openDetail(SongItem song) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      isScrollControlled: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: _SongDetailSheet(song: song, onOpenLink: _openLink),
      ),
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
                title: 'Şarkılarımız',
                subtitle: 'Bize hatırlatan ne varsa.',
              ),
              Expanded(
                child: FutureBuilder<List<SongItem>>(
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
                      return _empty('Şarkılar yüklenemedi.');
                    }
                    final songs = snapshot.data ?? const [];
                    if (songs.isEmpty) {
                      return _empty(
                        'Henüz şarkı eklenmedi.\n'
                        'assets/data/songs.json içine ekle.',
                      );
                    }
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(24, 8, 24, 32),
                          itemCount: songs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return AnimatedFadeSlide(
                              delay: Duration(milliseconds: 70 * index),
                              child: _SongTile(
                                song: song,
                                onTap: () => _openDetail(song),
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
              Icons.music_note_outlined,
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

class _SongTile extends StatelessWidget {
  const _SongTile({required this.song, required this.onTap});

  final SongItem song;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasLink = song.link != null && song.link!.isNotEmpty;
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  song.artist,
                  style: AppTextStyles.bodyMuted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (hasLink)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.open_in_new_rounded,
                color: AppColors.mutedText,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

class _SoftCloseButton extends StatelessWidget {
  const _SoftCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(7),
          child: Icon(
            Icons.close_rounded,
            color: AppColors.mutedText,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _SongDetailSheet extends StatelessWidget {
  const _SongDetailSheet({required this.song, required this.onOpenLink});

  final SongItem song;
  final Future<void> Function(String link) onOpenLink;

  @override
  Widget build(BuildContext context) {
    final hasLink = song.link != null && song.link!.isNotEmpty;
    final hasReason = song.reason != null && song.reason!.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AnimatedFadeSlide(
            duration: const Duration(milliseconds: 450),
            child: SoftCard(
              padding: const EdgeInsets.fromLTRB(26, 22, 18, 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.music_note_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: AppTextStyles.headlineMedium
                                    .copyWith(fontSize: 19),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                song.artist,
                                style: AppTextStyles.bodyMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _SoftCloseButton(
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                  if (hasReason) ...[
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        song.reason!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                  if (hasLink) ...[
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () => onOpenLink(song.link!),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Dinle'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
