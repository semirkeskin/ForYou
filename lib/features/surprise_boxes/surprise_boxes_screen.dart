import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surprise_box.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/page_header.dart';
import 'surprise_box_detail_screen.dart';
import 'widgets/surprise_box_card.dart';

class SurpriseBoxesScreen extends StatefulWidget {
  const SurpriseBoxesScreen({super.key});

  @override
  State<SurpriseBoxesScreen> createState() => _SurpriseBoxesScreenState();
}

class _SurpriseBoxesScreenState extends State<SurpriseBoxesScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final Future<List<SurpriseBox>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.loadSurpriseBoxes();
  }

  Future<void> _openBox(SurpriseBox box) async {
    if (box.requiresConfirmation) {
      final confirmed = await _askConfirmation();
      if (!mounted || confirmed != true) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => SurpriseBoxDetailScreen(box: box)),
    );
  }

  Future<bool?> _askConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Emin misin?',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
          ),
          content: Text(
            'Bunu gerçekten şimdi açmak istiyor musun?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Şimdi değil',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Aç'),
            ),
          ],
        );
      },
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
              title: 'Sürpriz Kutuları',
              subtitle: 'Doğru anda aç.',
            ),
            Expanded(
              child: FutureBuilder<List<SurpriseBox>>(
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
                    return const _Empty(message: 'Kutular yüklenemedi.');
                  }
                  final boxes = snapshot.data ?? const [];
                  if (boxes.isEmpty) {
                    return const _Empty(
                      message: 'Henüz kutu eklenmedi.',
                    );
                  }
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(24, 8, 24, 32),
                        itemCount: boxes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final box = boxes[index];
                          return SurpriseBoxCard(
                            box: box,
                            onTap: () => _openBox(box),
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

class _Empty extends StatelessWidget {
  const _Empty({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message, style: AppTextStyles.bodyMuted),
      ),
    );
  }
}
