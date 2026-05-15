import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/surprise_box.dart';
import '../../../shared/widgets/soft_card.dart';

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({
    super.key,
    required this.box,
    required this.onTap,
  });

  final SurpriseBox box;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(22, 22, 18, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(box.title, style: AppTextStyles.titleMedium),
                if (box.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    box.subtitle,
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.mutedText,
          ),
        ],
      ),
    );
  }
}
