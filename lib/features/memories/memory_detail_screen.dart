import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/memory_item.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/page_header.dart';

class MemoryDetailScreen extends StatelessWidget {
  const MemoryDetailScreen({super.key, required this.memory});

  final MemoryItem memory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PageHeader(title: memory.title, subtitle: memory.date),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: AnimatedFadeSlide(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Image.asset(
                                memory.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    Container(
                                  color:
                                      AppColors.accent.withOpacity(0.4),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 60,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            memory.description,
                            style: AppTextStyles.bodyLarge.copyWith(
                              height: 1.6,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
