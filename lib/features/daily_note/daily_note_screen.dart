import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/models/daily_note.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class DailyNoteScreen extends StatefulWidget {
  const DailyNoteScreen({super.key});

  @override
  State<DailyNoteScreen> createState() => _DailyNoteScreenState();
}

class _DailyNoteScreenState extends State<DailyNoteScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final Future<DailyNote?> _futureNote;

  @override
  void initState() {
    super.initState();
    _futureNote = _loadTodaysNote();
  }

  Future<DailyNote?> _loadTodaysNote() async {
    final notes = await _service.loadDailyNotes();
    if (notes.isEmpty) return null;
    final index = AppDateUtils.dailyIndex(notes.length);
    return notes[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              title: 'Bugünün Notu',
              subtitle: 'Sana özel, sadece bugüne.',
            ),
            Expanded(
              child: FutureBuilder<DailyNote?>(
                future: _futureNote,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return _EmptyState(
                      message: snapshot.hasError
                          ? 'Bugünün notu yüklenemedi.'
                          : 'Henüz bir not eklenmedi.',
                    );
                  }
                  return _NoteContent(note: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteContent extends StatelessWidget {
  const _NoteContent({required this.note});

  final DailyNote note;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: AnimatedFadeSlide(
            child: SoftCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    note.text,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 19,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '— bugün için',
                    style: AppTextStyles.bodyMuted.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMuted,
        ),
      ),
    );
  }
}
