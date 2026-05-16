import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/models/countdown_event.dart';
import '../../data/services/preferences_service.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key, required this.preferences});

  final PreferencesService preferences;

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late List<CountdownEvent> _events;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _events = widget.preferences.countdownEvents;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _events = widget.preferences.countdownEvents;
    });
  }

  Future<void> _openEditor({CountdownEvent? existing}) async {
    final result = await showModalBottomSheet<_EditorResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountdownEditorSheet(existing: existing),
    );
    if (!mounted || result == null) return;

    if (result.delete && existing != null) {
      await widget.preferences.removeCountdownEvent(existing.id);
    } else if (result.event != null) {
      await widget.preferences.upsertCountdownEvent(result.event!);
    }
    if (!mounted) return;
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Geri Sayım'),
      ),
      body: CherryBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              const PageHeader(
                title: 'Geri Sayım',
                subtitle: 'Kendi özel günlerini ekle.',
              ),
              Expanded(
                child: _events.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(24, 8, 24, 96),
                        itemCount: _events.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return AnimatedFadeSlide(
                            delay: Duration(milliseconds: 80 * index),
                            child: _CountdownCard(
                              event: event,
                              onTap: () => _openEditor(existing: event),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, size: 56, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              'Henüz geri sayım eklemedin.\nAlttaki + butonu ile başla.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({required this.event, required this.onTap});

  final CountdownEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final remaining = AppDateUtils.remaining(event.targetDate);
    final isPast = remaining.isNegative || remaining == Duration.zero;

    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 19),
                ),
              ),
              const Icon(
                Icons.edit_outlined,
                color: AppColors.mutedText,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isPast)
            Text(
              'Bugün o özel gün 💛',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
                fontSize: 22,
              ),
            )
          else
            _RemainingRow(remaining: remaining),
          const SizedBox(height: 10),
          Text(
            _formatDate(event.targetDate),
            style: AppTextStyles.bodyMuted.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)} '
        '${pad(date.hour)}:${pad(date.minute)}';
  }
}

class _RemainingRow extends StatelessWidget {
  const _RemainingRow({required this.remaining});

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
        _Unit(value: minutes, label: 'dk'),
        _Unit(value: seconds, label: 'sn'),
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
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: 32,
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.bodyMuted.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _EditorResult {
  const _EditorResult.save(this.event) : delete = false;
  const _EditorResult.deleteEvent()
      : event = null,
        delete = true;

  final CountdownEvent? event;
  final bool delete;
}

class _CountdownEditorSheet extends StatefulWidget {
  const _CountdownEditorSheet({this.existing});

  final CountdownEvent? existing;

  @override
  State<_CountdownEditorSheet> createState() => _CountdownEditorSheetState();
}

class _CountdownEditorSheetState extends State<_CountdownEditorSheet> {
  late final TextEditingController _titleController;
  late DateTime _selectedDate;
  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _selectedDate = existing?.targetDate ??
        DateTime.now().add(const Duration(days: 1)).copyWith(
              hour: 18,
              minute: 0,
              second: 0,
              millisecond: 0,
              microsecond: 0,
            );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bir başlık ekle')),
      );
      return;
    }
    final event = CountdownEvent(
      id: widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      targetDate: _selectedDate,
    );
    Navigator.of(context).pop(_EditorResult.save(event));
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bu geri sayımı silmek istiyor musun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pop(const _EditorResult.deleteEvent());
  }

  String _formatDate(DateTime date) {
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)}';
  }

  String _formatTime(DateTime date) {
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${pad(date.hour)}:${pad(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SoftCard(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isEdit ? 'Düzenle' : 'Yeni Geri Sayım',
                        style: AppTextStyles.headlineMedium
                            .copyWith(fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.mutedText,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Başlık',
                    hintText: 'Yıldönümümüz, doğum günü...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DateTimeTile(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tarih',
                        value: _formatDate(_selectedDate),
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateTimeTile(
                        icon: Icons.schedule_outlined,
                        label: 'Saat',
                        value: _formatTime(_selectedDate),
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_isEdit) ...[
                      TextButton.icon(
                        onPressed: _delete,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Sil'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                        ),
                      ),
                      const Spacer(),
                    ] else
                      const Spacer(),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text(_isEdit ? 'Kaydet' : 'Ekle'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.mutedText.withOpacity(0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.mutedText),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.bodyMuted.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
