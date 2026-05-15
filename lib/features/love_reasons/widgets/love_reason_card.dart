import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/soft_card.dart';

class LoveReasonCard extends StatelessWidget {
  const LoveReasonCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite_rounded,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(height: 18),
          Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 19,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
