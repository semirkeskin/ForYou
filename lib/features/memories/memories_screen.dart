import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/memory_item.dart';
import '../../data/services/local_json_service.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import 'memory_detail_screen.dart';
import 'widgets/memory_card.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  static const LocalJsonService _service = LocalJsonService();
  late final Future<List<MemoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.loadMemories();
  }

  void _openDetail(MemoryItem memory) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => MemoryDetailScreen(memory: memory),
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
                title: 'Anılarımız',
                subtitle: 'Birlikte topladıklarımız.',
              ),
            Expanded(
              child: FutureBuilder<List<MemoryItem>>(
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
                    return const _EmptyState(
                      message: 'Anılar yüklenemedi.',
                      icon: Icons.error_outline,
                    );
                  }
                  final memories = snapshot.data ?? const [];
                  if (memories.isEmpty) {
                    return const _EmptyState(
                      message:
                          'Henüz anı eklenmedi.\nFotoğrafları assets/images/memories/ klasörüne koyup\nmemories.json dosyasını güncelle.',
                      icon: Icons.photo_library_outlined,
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      final memory = memories[index];
                      return MemoryCard(
                        memory: memory,
                        onTap: () => _openDetail(memory),
                      );
                    },
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
  const _EmptyState({required this.message, required this.icon});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
