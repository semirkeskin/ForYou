import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/memory_item.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({super.key, required this.memory, required this.onTap});

  final MemoryItem memory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasText = memory.title != null || memory.date != null;
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Yazi yoksa foto tum karti doldurur (Expanded). Yazi varsa
              // alttan yazi bloku icin yer birakir.
              Expanded(child: _MemoryImage(path: memory.image)),
              if (hasText)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (memory.title != null)
                        Text(
                          memory.title!,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (memory.title != null && memory.date != null)
                        const SizedBox(height: 4),
                      if (memory.date != null)
                        Text(
                          memory.date!,
                          style: AppTextStyles.bodyMuted.copyWith(fontSize: 13),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoryImage extends StatelessWidget {
  const _MemoryImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) {
        return Container(
          color: AppColors.accent.withOpacity(0.4),
          child: const Center(
            child: Icon(
              Icons.image_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
