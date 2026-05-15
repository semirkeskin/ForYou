import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/surprise_box.dart';
import '../../shared/widgets/animated_fade_slide.dart';
import '../../shared/widgets/cherry_backdrop.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/soft_card.dart';

class SurpriseBoxDetailScreen extends StatelessWidget {
  const SurpriseBoxDetailScreen({super.key, required this.box});

  final SurpriseBox box;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CherryBackdrop(
        child: SafeArea(
        child: Column(
          children: [
            PageHeader(title: box.title, subtitle: box.subtitle),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: AnimatedFadeSlide(
                      duration: const Duration(milliseconds: 750),
                      child: SoftCard(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.primary,
                              size: 36,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              box.message,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontSize: 19,
                                height: 1.65,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
